//
//  ChangeModeController.swift
//  TrainMyEnglish
//
//  Created by Stanislav on 31.03.15.
//  Copyright (c) 2015 Stas Kirichok. All rights reserved.
//

import Foundation

class ChangeModeController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var sandboxPicker: UIPickerView!
    
    private var grammarForm: GrammarForm?
    private let pickerData = [Grammar.allTenses, Grammar.allAspects, Grammar.allMoods]
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSandboxPicker()
    }
    
    //MARK: Setup
    
    private func setupSandboxPicker() {
        
    }
    
    //MARK: Picker dataSource
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }

    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch(component) {
        case 0:
            return pickerView.bounds.width * 0.3
        case 1:
            return pickerView.bounds.width * 0.4
        case 2:
            return pickerView.bounds.width * 0.3
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var plainText = ""
        switch(component) {
        case 0:
            plainText = Grammar.allTenses[row]
        case 1:
            plainText = Grammar.allAspects[row]
        case 2:
            plainText = Grammar.allMoods[row]
        default:
            return nil
        }
        let font = UIFont(name: "Futura", size: 12)!
        return NSAttributedString(string: plainText, attributes: [NSFontAttributeName: font])
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var labelView = view as? UILabel
        if (labelView == nil) {
            let width = self.pickerView(pickerView, widthForComponent: component)
            let height = self.pickerView(pickerView, rowHeightForComponent: component)
            labelView = UILabel(frame: CGRectMake(0, 0, width, height))
            labelView!.text = pickerData[component][row]
            labelView!.numberOfLines = 0
            labelView!.lineBreakMode = NSLineBreakMode.ByWordWrapping
            labelView!.textAlignment = NSTextAlignment.Center
        }
        // Setup label properties - frame, font, colors etc
   
        
        return labelView!;
    }
    
    //MARK: Picker delegate
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
}

