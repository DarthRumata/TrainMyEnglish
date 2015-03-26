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

class CardTrainingController: UIViewController {
    @IBOutlet weak var sentencePanel: CardLayoutView!
    @IBOutlet weak var wordsPanel: CardLayoutView!
    @IBOutlet weak var wordsPanelHC: NSLayoutConstraint!
    
    private var movingCard: CardView?
    private var hoveredView: CardLayoutView?
    
    //MARK: update UI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.wordsPanelHC.constant = self.view.bounds.height * kWordPanelRatio
        self.sentencePanel.canReorder = true
        
        let recognizer = UIPanGestureRecognizer(target: self, action: Selector("panGesture:"))
        self.view.addGestureRecognizer(recognizer)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showCards()
    }
    
    //MARK: update UI
    
    func showCards() {
        self.wordsPanel.fillWithWords(WordsHandler.sharedInstance.getAllWords())
    }
    
    //MARK: Pan gesture
    
    func panGesture(recognizer: UIPanGestureRecognizer) {
        if (recognizer.state == UIGestureRecognizerState.Began) {
            let location = recognizer.locationInView(recognizer.view)
            if let cardView = recognizer.view?.hitTest(location, withEvent: nil) as? CardView {
                self.movingCard = cardView
                self.view.bringSubviewToFront(self.movingCard!.superview!)
                self.movingCard!.superview!.bringSubviewToFront(self.movingCard!)
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
                UIView.animateWithDuration(0.2, animations: { () -> Void in
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
    
    
}

