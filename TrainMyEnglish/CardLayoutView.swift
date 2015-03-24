//
// Created by Stas Kirichok on 22.03.15.
// Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation
import UIKit

private let kAnimationTime: NSTimeInterval = 0.7
private let kInteritemSpace: CGFloat = 15

class CardLayoutView: UIView {

    var cards = [CardView]()

    func fillWithWords(words: Array<Word>) {
        let startOrigin = CGPointMake(kInteritemSpace, 0)
        var currentCenter: CGPoint!
        for word in words {
            var lastWidth: CGFloat = 0
            if let lastCard = self.cards.last {
                lastWidth = lastCard.bounds.width
            }

            let card = CardView.createWithWord(word)
            let type = self.generateStartPosition(card)
            self.cards.append(card)
            self.addSubview(card)

            UIView.transitionWithView(card, duration: kAnimationTime, options: type, animations: {
                () -> Void in
                if currentCenter == nil {
                    currentCenter = CGPointMake(startOrigin.x + card.bounds.width / 2, startOrigin.y + card.bounds.width / 2)
                } else if (currentCenter.x + kInteritemSpace + lastWidth * 0.5 + card.bounds.width <= self.bounds.width - kInteritemSpace) {
                    currentCenter.x += kInteritemSpace + card.bounds.width * 0.5 + lastWidth * 0.5
                } else {
                    currentCenter = CGPointMake(startOrigin.x + card.bounds.width / 2, currentCenter.y + card.bounds.height + kInteritemSpace)
                }
                card.center = currentCenter
            }, completion: {
                (let finish) -> Void in

            })
        }
    }

    enum StartPositionType: Int {
        case Left = 0, Right, Bottom
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
