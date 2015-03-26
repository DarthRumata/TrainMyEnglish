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
    
    var canReorder = false
    
    private var cards = [CardView]()
    
    private enum StartPositionType: Int {
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
            
            card.xOffsetConstraint = card.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: currentOrigin.x)
            card.yOffsetConstraint = card.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: currentOrigin.y)
        }
        
        UIView.animateWithDuration(kFillAnimationTime) { () -> Void in
            self.layoutIfNeeded()
        }
    }
    
    func addCard(card: CardView) {
        var index = self.cards.count
        if (self.canReorder) {
            var maxIntersectionSquare: CGFloat = 0
            for var i = 0; i < self.cards.count; i++ {
                let listCard = self.cards[i]
                let square = CGRectIntersection(card.frame, listCard.frame).square
                if (square > maxIntersectionSquare) {
                    maxIntersectionSquare = square
                    index = i
                }
            }
        }
        self.insertCard(card, index: index)
    }
    
    func insertCard(card: CardView, index: Int) {
        var currentOrigin: CGPoint!
        if (self.cards.count == 0 || index == 0) {
            currentOrigin = startOrigin;
        } else {
            let lastCard = index >= self.cards.count ? self.cards.last! : self.cards[index - 1]
            if (lastCard.frame.origin.x + lastCard.bounds.width + kInteritemSpace * 2 + card.bounds.width <= self.bounds.width) {
                currentOrigin = CGPointMake(lastCard.frame.origin.x + lastCard.bounds.width + kInteritemSpace, lastCard.frame.origin.y)
            } else {
                currentOrigin = CGPointMake(startOrigin.x, lastCard.frame.origin.y + card.bounds.height + kInteritemSpace)
            }
        }
        self.cards.insert(card, atIndex: index)
        
        self.addSubview(card)
        
        card.xOffsetConstraint = card.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: currentOrigin.x)
        card.yOffsetConstraint = card.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: currentOrigin.y)
        
        self.rearrangeCards(index + 1, to: self.cards.count - 1)
    }
    
    func removeCard(card: CardView) {
        card.removeFromSuperview()
        let index = find(self.cards, card)!
        self.cards.removeAtIndex(index)
        self.rearrangeCards(index, to: (self.cards.count - 1))
    }
    
    private func rearrangeCards(from: Int, to: Int) {
        if (from < self.cards.count) {
            for i in from...to {
                let previousCard: CardView? = i > 0 ? self.cards[i-1] : nil
                let currentCard = self.cards[i]
                if (previousCard != nil) {
                    if (self.canBePlacedInSameRow(previousCard!, currentCard: currentCard)) {
                        currentCard.xOffsetConstraint.constant = previousCard!.xOffsetConstraint.constant + previousCard!.widthConstraint.constant + kInteritemSpace
                        currentCard.yOffsetConstraint.constant = previousCard!.yOffsetConstraint.constant
                    } else {
                        currentCard.xOffsetConstraint.constant = startOrigin.x
                        currentCard.yOffsetConstraint.constant = previousCard!.yOffsetConstraint.constant + previousCard!.bounds.height + kInteritemSpace
                    }
                } else {
                    currentCard.xOffsetConstraint.constant = startOrigin.x
                    currentCard.yOffsetConstraint.constant = startOrigin.y
                }  
            }
        }
        
        UIView.animateWithDuration(kArrangeAnimationTime, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    private func canBePlacedInSameRow(previousCard: CardView, currentCard: CardView) -> Bool {
        return previousCard.xOffsetConstraint.constant + previousCard.widthConstraint.constant + 2 * kInteritemSpace + currentCard.widthConstraint.constant <= self.bounds.width
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
