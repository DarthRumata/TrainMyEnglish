//
// Created by Stas Kirichok on 22.03.15.
// Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation
import UIKit

private let kFillAnimationTime: NSTimeInterval = 1
private let kArrangeAnimationTime: NSTimeInterval = 0.2
private let kInteritemSpace: CGFloat = 15
private let startOrigin = CGPointMake(kInteritemSpace, kInteritemSpace)

class CardLayoutView: UIView {
    
    var cards = [CardView]()
    
    enum StartPositionType: Int {
        case Left = 0, Right, Bottom
    }
    
    func fillWithWords(words: Array<Word>) {
        
        var currentOrigin: CGPoint!
        for word in words {
            var lastWidth: CGFloat = 0
            if let lastCard = self.cards.last {
                lastWidth = lastCard.bounds.width
            }
            
            let card = CardView.createWithWord(word)
            let type = self.generateStartPosition(card)
            self.cards.append(card)
            self.addSubview(card)
            
            if currentOrigin == nil {
                currentOrigin = startOrigin;
            } else if (currentOrigin.x + lastWidth + kInteritemSpace * 2 + card.bounds.width <= self.bounds.width) {
                currentOrigin.x += lastWidth + kInteritemSpace
            } else {
                currentOrigin = CGPointMake(startOrigin.x, currentOrigin.y + card.bounds.height + kInteritemSpace)
            }
            card.widthConstraint = card.autoSetDimension(ALDimension.Width, toSize: card.bounds.width)
            card.autoSetDimension(ALDimension.Height, toSize: card.bounds.height)
            
            card.xOffsetConstraint = card.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: currentOrigin.x)
            card.yOffsetConstraint = card.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: currentOrigin.y)
        }
        
        UIView.animateWithDuration(kFillAnimationTime) { () -> Void in
            self.layoutIfNeeded()
        }
    }
    
    func addCard(card: CardView) {
        var currentOrigin: CGPoint!
        if (self.cards.count == 0) {
            currentOrigin = startOrigin;
        } else {
            let lastCard = self.cards.last!
            if (lastCard.frame.origin.x + lastCard.bounds.width + kInteritemSpace * 2 + card.bounds.width <= self.bounds.width) {
                currentOrigin = CGPointMake(lastCard.frame.origin.x + lastCard.bounds.width + kInteritemSpace, lastCard.frame.origin.y)
            } else {
                currentOrigin = CGPointMake(startOrigin.x, lastCard.frame.origin.y + card.bounds.height + kInteritemSpace)
            }
        }
        self.cards.append(card)
       
        self.addSubview(card)
        
        card.xOffsetConstraint = card.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: currentOrigin.x)
        card.yOffsetConstraint = card.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: currentOrigin.y)
        
        UIView.animateWithDuration(kArrangeAnimationTime, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.layoutIfNeeded()
            }, completion: nil)
        
        
    }
    
    func removeCard(card: CardView) {
        card.removeFromSuperview()
        let index = find(self.cards, card)!
        self.cards.removeAtIndex(index)
        if (index == self.cards.count) {
            return
        }
        //now index points to next card after removed
        for i in index...(self.cards.count - 1) {
            let previousCard: CardView? = i > 0 ? self.cards[i-1] : nil
            let currentCard = self.cards[i]
            if (previousCard != nil) {
                if (previousCard!.yOffsetConstraint.constant == currentCard.yOffsetConstraint.constant) {
                    currentCard.xOffsetConstraint.constant = previousCard!.xOffsetConstraint.constant + previousCard!.widthConstraint.constant + kInteritemSpace
                } else {
                    if (previousCard!.xOffsetConstraint.constant + previousCard!.widthConstraint.constant + 2 * kInteritemSpace + card.widthConstraint.constant <= self.bounds.width) {
                        currentCard.xOffsetConstraint.constant = previousCard!.xOffsetConstraint.constant + previousCard!.widthConstraint.constant + kInteritemSpace
                        currentCard.yOffsetConstraint.constant = previousCard!.yOffsetConstraint.constant
                    } else {
                        currentCard.xOffsetConstraint.constant = startOrigin.x
                    }
                }
            } else {
                currentCard.xOffsetConstraint.constant = startOrigin.x
            }
            
        }
        UIView.animateWithDuration(kArrangeAnimationTime, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func generateStartPosition(card: CardView) -> UIViewAnimationOptions {
        let type = StartPositionType(rawValue: Random.rndInt(StartPositionType.Left.rawValue, StartPositionType.Bottom.rawValue))!
        
        var rndX: CGFloat
        var rndY: CGFloat
        var option: UIViewAnimationOptions
        switch type {
        case .Left:
            rndX = -card.bounds.width / 2
            rndY = CGFloat(Random.rndInt(Int(-card.bounds.height / 2), Int(self.bounds.height + card.bounds.height / 2)))
            option = UIViewAnimationOptions.TransitionFlipFromLeft
            
        case .Right:
            rndX = self.bounds.width + card.bounds.width / 2
            rndY = CGFloat(Random.rndInt(Int(-card.bounds.height / 2), Int(self.bounds.height + card.bounds.height / 2)))
            option = UIViewAnimationOptions.TransitionFlipFromRight
            
        case .Bottom:
            rndX = CGFloat(Random.rndInt(Int(-card.bounds.width / 2), Int(self.bounds.width + card.bounds.width / 2)))
            rndY = self.bounds.height + card.bounds.width / 2
            option = UIViewAnimationOptions.TransitionFlipFromBottom
        }
        
        card.center = CGPointMake(rndX, rndY)
        
        return option
    }
    
}
