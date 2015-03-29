//
//  CardView.swift
//  TrainMyEnglish
//
//  Created by Stas Kirichok on 16.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation
import UIKit

let kTapCardNotification = "TapCardNotification"

private let kSideOffset: CGFloat = 15
private let kMinWidth: CGFloat = 60

class CardView: UIView {
    
    @IBOutlet weak var wordTitle: UILabel!
    
    var widthConstraint: NSLayoutConstraint!
    var xOffsetConstraint: NSLayoutConstraint!
    var yOffsetConstraint: NSLayoutConstraint!
    
    private(set) var word: Word!
    private(set) var currentForm: String!
    
    var layoutView: CardLayoutView {
        return self.superview as! CardLayoutView
    }
    
    class func createWithWord(word: Word) -> CardView {
        let cardView: CardView = NSBundle.mainBundle().loadNibNamed("CardView", owner: nil, options: nil)[0] as! CardView
        cardView.word = word
        cardView.applyWordForm(word.base)
        return cardView
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    func applyWordForm(text: String) {
        currentForm = text
        let upperText = text.uppercaseString
        self.wordTitle.text = upperText
        let maxWidth: CGFloat = UIScreen.mainScreen().bounds.width - kSideOffset * 2
        var calculateWidth = ceil((upperText as NSString).boundingRectWithSize(
            CGSizeMake(maxWidth, self.wordTitle.bounds.height),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: wordTitle.font],
            context: nil
            ).width + kSideOffset * 2)
        calculateWidth = calculateWidth < kMinWidth ? kMinWidth : calculateWidth
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, calculateWidth, self.frame.height)
        if (self.widthConstraint == nil) {
            self.widthConstraint = self.autoSetDimension(ALDimension.Width, toSize: self.bounds.width)
            self.autoSetDimension(ALDimension.Height, toSize: self.bounds.height)
        } else {
           self.widthConstraint.constant = self.bounds.width
        }

        self.layoutIfNeeded()
    }
    
}
