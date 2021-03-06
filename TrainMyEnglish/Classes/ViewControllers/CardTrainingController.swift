//
//  CardTrainingController.swift
//  TrainMyEnglish
//
//  Created by Stas Kirichok on 15.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import UIKit

private let kSpaceBetweenPanels: CGFloat = 50
private let kWordPanelRatio: CGFloat = 0.6
private let kCancelMovementDuration = 0.2

class CardTrainingController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var sentencePanel: CardLayoutView!
    @IBOutlet weak var wordsPanel: CardLayoutView!
    @IBOutlet weak var wordsPanelHC: NSLayoutConstraint!
    @IBOutlet weak var taskActiveArea: UIButton!
    
    private var movingCard: CardView?
    private var hoveredView: CardLayoutView?
    
    private var currentTask: Task?
    
    //MARK: update UI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.wordsPanelHC.constant = self.view.bounds.height * kWordPanelRatio
        self.sentencePanel.canReorder = true
        EditCardView.presentingView = self.view
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: Selector("panGesture:"))
        self.view.addGestureRecognizer(panRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("cardTapped:"))
        tapRecognizer.delegate = self
        self.view.addGestureRecognizer(tapRecognizer)
        
        //data
        self.updateTask()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showCards()
    }
    
    //MARK: Logic
    func updateTask() {
        self.currentTask = TaskHandler.sharedInstance.nextTask()
        self.taskActiveArea.setTitle(self.currentTask!.description, forState: UIControlState.Normal)
    }
    
    //MARK: update UI
    
    func showCards() {
        self.wordsPanel.fillWithWords(self.currentTask!.words)
    }
    
    //MARK: Pan gesture
    
    func panGesture(recognizer: UIPanGestureRecognizer) {
        if (recognizer.state == UIGestureRecognizerState.Began) {
            let location = recognizer.locationInView(recognizer.view)
            if let cardView = recognizer.view?.hitTest(location, withEvent: nil) as? CardView {
                self.movingCard = cardView
                self.moveCardToVeryTop(self.movingCard!)
            }
        } else if (recognizer.state == UIGestureRecognizerState.Changed) {
            if (self.movingCard == nil) {
                return
            }
            
            let globalCenter = self.movingCard!.superview!.convertPoint(CGPointMake(self.movingCard!.frame.midX, self.movingCard!.frame.midY) , toView: self.view)
            if (CGRectContainsPoint(self.wordsPanel.frame, globalCenter)) {
                hoveredView = self.wordsPanel
            } else if (CGRectContainsPoint(self.sentencePanel.frame, globalCenter)) {
                hoveredView = self.sentencePanel
            } else {
                hoveredView = nil
            }
            
            let translation = recognizer.translationInView(self.view)
            self.movingCard!.transform = CGAffineTransformMakeTranslation(translation.x, translation.y)
        } else if (recognizer.state == UIGestureRecognizerState.Ended || recognizer.state == UIGestureRecognizerState.Cancelled) {
            if (self.movingCard == nil) {
                return
            }
            
            if (hoveredView == nil || (self.movingCard!.superview! == hoveredView! && !hoveredView!.canReorder)) {
                UIView.animateWithDuration(kCancelMovementDuration, animations: { () -> Void in
                    self.movingCard!.transform = CGAffineTransformIdentity
                    }, completion: { (let finish) -> Void in
                        self.movingCard = nil
                        self.hoveredView = nil
                })
            } else {
                //finding view position in new superview
                let currentOrigin = self.movingCard!.layer.presentationLayer()!.frame.origin
                let convertedOrigin = CGPointMake(currentOrigin.x + self.movingCard!.superview!.frame.origin.x - self.hoveredView!.frame.origin.x, currentOrigin.y + self.movingCard!.superview!.frame.origin.y - self.hoveredView!.frame.origin.y)
                self.movingCard!.transform = CGAffineTransformIdentity
                (self.movingCard!.superview! as! CardLayoutView).removeCard(self.movingCard!)
                
                //correct view position after animation
                self.movingCard!.frame = CGRectMake(convertedOrigin.x, convertedOrigin.y, self.movingCard!.frame.width, self.movingCard!.frame.height)
                self.hoveredView!.addCard(self.movingCard!)
                
                self.movingCard = nil
                self.hoveredView = nil
            }
        }
    }
    
    //MARK: Tap gesture
    
    func cardTapped(recognizer: UITapGestureRecognizer) {
        let location = recognizer.locationInView(recognizer.view)
        let cardView = recognizer.view?.hitTest(location, withEvent: nil) as? CardView
        if cardView != nil && !EditCardView.isVisible {
            self.moveCardToVeryTop(cardView!)
            EditCardView.show(cardView!, canDelete: true)
        } else {
            EditCardView.hide()
        }

    }
    
    private func moveCardToVeryTop(card: CardView) {
        self.view.bringSubviewToFront(card.superview!)
        card.superview!.bringSubviewToFront(card)
    }
    
    //MARK: Gesture recognizer delegate
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        let location = touch.locationInView(gestureRecognizer.view)
        return !EditCardView.containsPoint(location, inView: self.view)
    }
    
}

