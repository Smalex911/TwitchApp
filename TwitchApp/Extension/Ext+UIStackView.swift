//
//  Ext+UIStackView.swift
//  TwitchApp
//
//  Created by Aleksandr Smorodov on 31.03.2021.
//

import UIKit

extension UIStackView {
    
    @discardableResult
    func addSpace(width: CGFloat? = nil, height: CGFloat? = nil) -> UIView {
        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: width ?? 10, height: height ?? 10))
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        
        addArrangedSubview(spaceView)
        
        if let width = width {
            addConstraint(spaceView.widthAnchor.constraint(equalToConstant: width))
        }
        
        if let height = height {
            addConstraint(spaceView.heightAnchor.constraint(equalToConstant: height))
        }
        return spaceView
    }
}
