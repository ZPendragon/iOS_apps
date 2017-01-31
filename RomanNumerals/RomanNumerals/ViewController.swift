//
//  ViewController.swift
//  RomanNumerals
//
//  Created by Kevin Zeckser on 5/25/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties & Outlets
    @IBOutlet fileprivate weak var numeralTextField: UITextField!
    @IBOutlet fileprivate weak var resultLabel: UILabel!
    fileprivate var manager = RNManager()
    
    // MARK: Actions & Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numeralTextField.delegate = self
    }
    
    override internal func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction fileprivate func performConversion(_ sender: UIButton) {
        if let enteredText = numeralTextField.text, let text = Int(enteredText)  {
           resultLabel.text = manager.convertToRomanNumeral(text)
           //resultLabel.text = manager.recursiveRomanNumeral(text)
        } else {
            resultLabel.text = "Not a valid number."
        }
    }
    
    
}

