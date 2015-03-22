//
//  CardView.swift
//  TrainMyEnglish
//
//  Created by Stas Kirichok on 16.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation
import UIKit

class CardView: UIView {
    
    @IBOutlet weak var wordTitle: UILabel!
    let kSideOffset: CGFloat = 15
    let kMinWidth: CGFloat = 60
    
    class func createWithWord(word: Word) -> CardView {
        let cardView: CardView = NSBundle.mainBundle().loadNibNamed("CardView", owner: nil, options: nil)[0] as CardView
        cardView.setWord(word)
        return cardView
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setWord(word: Word) {
        self.wordTitle.text = word.base
        let maxWidth: CGFloat = UIScreen.mainScreen().bounds.width - self.kSideOffset * 2
       var calculateWidth = ceil((word.base as NSString).boundingRectWithSize(
            CGSizeMake(maxWidth, self.wordTitle.bounds.height),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: wordTitle.font],
            context: nil
        ).width + self.kSideOffset * 2)
        calculateWidth = calculateWidth < self.kMinWidth ? self.kMinWidth : calculateWidth
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, calculateWidth, self.frame.height)
        self.layoutIfNeeded()
    }
    
}
