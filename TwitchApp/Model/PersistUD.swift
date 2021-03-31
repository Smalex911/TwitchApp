//
//  PersistUD.swift
//  TwitchApp
//
//  Created by Aleksandr Smorodov on 31.03.2021.
//

import Foundation

@propertyWrapper
struct PersistUD<T: Codable> {
    let key: String
    let defaultValue: T?
    
    var wrappedValue: T? {
        get {
            if let data = UserDefaults.standard.object(forKey: key) as? T { return data }
            
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return defaultValue }
            return (try? PropertyListDecoder().decode(T.self, from: data)) ?? defaultValue
        }
        set {
            UserDefaults.standard.set((try? PropertyListEncoder().encode(newValue)) ?? newValue, forKey: key)
        }
    }
}

@propertyWrapper
struct PersistUDTemp<T: Codable> {
    let key: String
    let defaultValue: T?
    
    var _wrappedValue: T?
    
    var wrappedValue: T? {
        mutating get {
            if let value = _wrappedValue { return value }
            if let data = UserDefaults.standard.object(forKey: key) as? T {
                _wrappedValue = data
                return data
            }
            
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return defaultValue }
            if let value = (try? PropertyListDecoder().decode(T.self, from: data)) {
                _wrappedValue = value
                return value
            }
            return defaultValue
        }
        set {
            _wrappedValue = newValue
            UserDefaults.standard.set((try? PropertyListEncoder().encode(newValue)) ?? newValue, forKey: key)
        }
    }
}
