//
//  CardTrainingController.swift
//  TrainMyEnglish
//
//  Created by Stas Kirichok on 15.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import UIKit

private let kSpaceBetweenPanels: CGFloat = 50
private let kWordPanelRatio: CGFloat = 2 / 3

class CardTrainingController: UIViewController {
    @IBOutlet weak var sentencePanel: CardLayoutView!
    @IBOutlet weak var wordsPanel: CardLayoutView!
    @IBOutlet weak var wordsPanelHC: NSLayoutConstraint!
    
    //MARK: update UI

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.wordsPanelHC.constant = self.view.bounds.height * kWordPanelRatio
        
        self.showCards()
    }

    //MARK: update UI
    
    func showCards() {
        self.wordsPanel.fillWithWords(WordsHandler.sharedInstance.getAllWords())
    }
    



}

