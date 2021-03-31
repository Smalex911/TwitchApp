//
//  XibView.swift
//  TwitchApp
//
//  Created by Aleksandr Smorodov on 31.03.2021.
//

import UIKit

class XibView: UIView {
    
    deinit {
        #if DEBUG
        print("\(type(of: self)) deinit")
        #endif
    }
    
    var targetView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
        awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
        awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        targetView.frame = bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        style()
    }
    
    func style() {
        
    }
    
    func commonInit() {
        targetView = loadViewFromNib()
        targetView.frame = bounds
        targetView.translatesAutoresizingMaskIntoConstraints = false
        targetView.backgroundColor = .clear
        
        addSubview(targetView)
        
        backgroundColor = .clear
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|", metrics: nil, views: ["childView": targetView as Any]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|", metrics: nil, views: ["childView": targetView as Any]))
    }
    
    func loadViewFromNib() -> UIView? {
        let name = type(of: self).description().components(separatedBy: ".").last!
        return UINib(nibName: name, bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView
    }
}
