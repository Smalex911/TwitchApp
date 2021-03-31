//
//  SettingsInfo.swift
//  TwitchApp
//
//  Created by Aleksandr Smorodov on 08.11.2020.
//

import Foundation

class SettingsInfo: Codable {
    
    var channelName: String?
    
    var chatTransparency: Float = 1
    var chatWidth: Float = 300
    
    var videoDarker: Float = 0
    var blockTap: Bool = false
    
    var showBonuses: Bool = false
    
    var isLogged: Bool = false
}
