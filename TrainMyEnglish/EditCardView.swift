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
private let kShowDuration = 1.2
private let kContentDelay = 0.12
private let kDefaultSize = CGSizeMake(275, 290)

class EditCardView: UIView, UITableViewDataSource, UITableViewDelegate {
  
    @IBOutlet weak var translatioTitle: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var options = [String]()
    static var instance: EditCardView!
    
    //MARK: View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.table.registerClass(UITableViewCell.self, forCellReuseIdentifier: kCellIdentifier)
    }
    
    class func show(fromCardView: CardView, canDelete: Bool) {
        instance = NSBundle.mainBundle().loadNibNamed("EditCardView", owner: nil, options: nil)[0] as! EditCardView
        instance.frame = fromCardView.frame
        instance.hideAllContent(true)
        fromCardView.superview!.addSubview(instance)
        
        UIView.animateWithDuration(kShowDuration, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            let screenCenter = fromCardView.superview!.convertPoint(UIScreen.mainScreen().applicationFrame.center, fromCoordinateSpace: UIScreen.mainScreen().coordinateSpace)
            self.instance.frame = self.instance.frame.makeCoverRectCloserToPoint(screenCenter, size: kDefaultSize)
        }, completion: nil)
        
        UIView.animateWithDuration(kShowDuration - kContentDelay, delay: kContentDelay, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.instance.hideAllContent(false)
            self.instance.layoutIfNeeded()
            }, completion: nil)
        
        let word = fromCardView.word
        if let verb = word as? Verb {
           instance.options += verb.forms.values.array
        } else if let noun = word as? Noun {
            instance.options += [noun.plural]
        }
        
        instance.deleteBtn.enabled = canDelete
        
        instance.table.reloadData()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.hide()
        }
    }
    
    class func hide() {
        self.instance.removeFromSuperview()
        self.instance = nil
    }
    
    func hideAllContent(hide: Bool) {
        for view: UIView in self.subviews as! [UIView] {
            view.alpha = hide ? 0 : 1
        }
    }
    
    //MARK: Actions
    
    @IBAction func deleteAction(sender: UIButton) {
        
    }
    
    @IBAction func confirmAction(sender: AnyObject) {
        
    }
    
    //MARK: TableView delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        return cell
    }
}

