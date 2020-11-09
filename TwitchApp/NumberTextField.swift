//
//  NumberTextField.swift
//  TwitchApp
//
//  Created by Aleksandr Smorodov on 08.11.2020.
//

import UIKit

class NumberTextFieldView: UITextField {
    
    var didNext: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        keyboardType = .numbersAndPunctuation
        delegate = self
    }
}

extension NumberTextFieldView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        didNext?()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "0123456789-"
        guard !allowedCharacters.contains(string) && range.length != 1 else { return true }
        
        let nsString = textField.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string.onlyDigints)
        
        textField.text = newString
        return false
    }
}
