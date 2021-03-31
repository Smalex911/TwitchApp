//
//  SettingsService.swift
//  TwitchApp
//
//  Created by Aleksandr Smorodov on 31.03.2021.
//

import Foundation

class SettingsService {
    
    static var shared = SettingsService()
    
    @PersistUD(key: "SettingsModel", defaultValue: nil)
    var settings: SettingsInfo?
    
    @PersistUDTemp(key: "ChannelNames", defaultValue: nil)
    var channelNames: [String]?
    
    
    func appendChannelName(_ name: String?) {
        guard let name = name?.notEmptyValue else { return }
        
        var names = channelNames ?? []
        names.removeAll(where: { $0 == name })
        names.insert(name, at: 0)
        
        channelNames = names
    }
    
    func removeChannelName(_ name: String?) {
        guard let name = name?.notEmptyValue else { return }
        
        var names = channelNames ?? []
        names.removeAll(where: { $0 == name })
        
        channelNames = names
    }
}
