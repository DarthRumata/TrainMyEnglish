//
//  EditCardView.swift
//  TrainMyEnglish
//
//  Created by Stanislav on 26.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation
import UIKit

private let kCellIdentifier = "optionCell"
private let kShowDuration = 0.6
private let kHideDuration = 0.3
private let kContentDelay = 0.12
private let kDefaultSize = CGSizeMake(275, 290)

class EditCardView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var translationTitle: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var mainTitle: UILabel!
    
    static var presentingView: UIView!
    
    private var options = [String]()
    private var chosenOption: String!
    private var baseFrame: CGRect!
    private var isOptionChanged = false
    private var confirmActionBlock: ((option: String) -> Void)!
    private var deleteActionBlock: ((option: String) -> Void)!
    private static var instance: EditCardView!
    
    private(set) static var isVisible = false
    
    //MARK: View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.table.registerClass(UITableViewCell.self, forCellReuseIdentifier: kCellIdentifier)
        self.table.tableFooterView = UIView()
    }
    
    class func show(cardView: CardView, canDelete: Bool) {
        if (self.isVisible) {
            return
        }
        isVisible = true
        instance = NSBundle.mainBundle().loadNibNamed("EditCardView", owner: nil, options: nil)[0] as! EditCardView
        instance.baseFrame = self.presentingView.convertRect(cardView.frame, fromView: cardView.superview!)
        instance.frame = instance.baseFrame
        instance.hideAllContent(true)
        self.presentingView.addSubview(instance)
        
        UIView.animateWithDuration(kShowDuration, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            let screenCenter = self.presentingView.center
            self.instance.frame = self.instance.frame.makeCoverRectCloserToPoint(screenCenter, size: kDefaultSize)
            }, completion: nil)
        
        UIView.animateWithDuration(kShowDuration - kContentDelay, delay: kContentDelay, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.instance.hideAllContent(false)
            }, completion: {(finish) -> Void in
                self.instance.layoutIfNeeded()
        })
        
        let word = cardView.word
        self.instance.chosenOption = cardView.currentForm
        self.instance.confirmActionBlock = { (option) -> Void in
            cardView.applyWordForm(option)
            cardView.layoutView.rearrangeAllCards()
        }
        self.instance.setup(word)
        self.instance.deleteBtn.enabled = canDelete
        self.instance.updateConfirmBtn()
    }
    
    class func hide() {
        if (!self.isVisible) {
            return
        }
        isVisible = false
        UIView.animateWithDuration(kHideDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.instance.frame = self.instance.baseFrame
            
            self.instance.alpha = 0.1
            }, completion: {(finish) -> Void in
                self.instance.removeFromSuperview()
                self.instance = nil
        })
        
        UIView.animateWithDuration(kContentDelay, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.instance.hideAllContent(true)
            self.instance.layoutIfNeeded()
            }, completion: nil)
    }
    
    class func containsPoint(point: CGPoint, inView: UIView) -> Bool {
        if (self.instance == nil) {
            return false
        }
        return self.instance.frame.contains(point)
    }
    
    //MARK: Update UI
    
    private func updateConfirmBtn() {
        self.confirmBtn.setTitle(self.isOptionChanged ? "Confirm" : "OK", forState: UIControlState.Normal)
    }
    
    private func hideAllContent(hide: Bool) {
        for view: UIView in self.subviews as! [UIView] {
            view.alpha = hide ? 0 : 1
        }
    }
    
    private func updateMainTitle() {
        self.mainTitle.text =  "Edit: " + self.chosenOption.uppercaseString
    }
    
    //MARK: Actions
    
    @IBAction func deleteAction(sender: UIButton) {
        
    }
    
    @IBAction func confirmAction(sender: AnyObject) {
        EditCardView.hide()
        if (self.isOptionChanged) {
            self.confirmActionBlock(option: self.chosenOption)
        }
    }
    
    //MARK: Logic
    
    func setup(word: Word) {
        self.options += word.formList(self.chosenOption)
        
        self.updateMainTitle()
        self.translationTitle.text = word.translation.uppercaseString
        
        self.table.reloadData()
    }
    
    //MARK: TableView delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = options[indexPath.row].uppercaseString
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        self.isOptionChanged = true
        self.options.insert(self.chosenOption, atIndex: indexPath.row)
        self.chosenOption = self.options[indexPath.row + 1]
        self.options.removeAtIndex(indexPath.row + 1)
        
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        tableView.endUpdates()
        
        self.updateMainTitle()
        self.updateConfirmBtn()
    }
}

