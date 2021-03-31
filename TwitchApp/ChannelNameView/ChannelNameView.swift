//
//  ChannelNameView.swift
//  TwitchApp
//
//  Created by Aleksandr Smorodov on 31.03.2021.
//  
//

import UIKit

class ChannelNameView: XibView {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonRemove: UIButton!
    
    typealias EntityType = String
    
    var didSelect: ((EntityType) -> Void)?
    var didRemove: ((EntityType) -> Void)?
    
    var entity: EntityType? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttonRemove.addTarget(self, action: #selector(removeHandler), for: .touchUpInside)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHandler)))
    }
    
    override func style() {
        super.style()
        
    }
    
    func updateUI() {
        labelTitle.text = entity
    }
    
    @objc func removeHandler() {
        guard let entity = entity else { return }
        didRemove?(entity)
    }
    
    @objc func selectHandler() {
        guard let entity = entity else { return }
        didSelect?(entity)
    }
}
