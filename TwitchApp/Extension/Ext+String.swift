//
//  Ext+String.swift
//  TwitchApp
//
//  Created by Aleksandr Smorodov on 08.11.2020.
//

import Foundation

extension String {
    
    var notEmptyValue: String? {
        let value = trimmingCharacters(in: .whitespaces)
        return value != "" ? value : nil
    }
    
    var onlyDigints: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}
