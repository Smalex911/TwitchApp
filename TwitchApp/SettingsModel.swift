//
//  SettingsModel.swift
//  TwitchApp
//
//  Created by Aleksandr Smorodov on 08.11.2020.
//

import Foundation

class SettingsModel: Codable {
    
    var channelName: String?
    
    var chatTransparency: Float = 1
    var chatWidth: Float = 300
    
    var videoDarker: Float = 0
    var blockTap: Bool = false
    
    var showBonuses: Bool = false
    
    var isLogged: Bool = false
    
    func store() {
        UserDefaults.standard.set((try? PropertyListEncoder().encode(self)) ?? self, forKey: "SettingsModel")
    }
    
    static func restore() -> SettingsModel {
        if let data = UserDefaults.standard.object(forKey: "SettingsModel") as? SettingsModel { return data }
        
        guard let data = UserDefaults.standard.object(forKey: "SettingsModel") as? Data else { return SettingsModel() }
        return (try? PropertyListDecoder().decode(SettingsModel.self, from: data)) ?? SettingsModel()
        
    }
}
