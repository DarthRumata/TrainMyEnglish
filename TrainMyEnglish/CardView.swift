//
//  CardView.swift
//  TrainMyEnglish
//
//  Created by Stas Kirichok on 16.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation
import UIKit

private let kSideOffset: CGFloat = 15
private let kMinWidth: CGFloat = 60

class CardView: UIView {
    
    @IBOutlet weak var wordTitle: UILabel!
    
    var widthConstraint: NSLayoutConstraint!
    var xOffsetConstraint: NSLayoutConstraint!
    var yOffsetConstraint: NSLayoutConstraint!
    
    private var word: Word!
    
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
        self.layoutIfNeeded()
    }
    
}
