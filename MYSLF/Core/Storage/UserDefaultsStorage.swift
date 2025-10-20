//
//  UserDefaultsService.swift
//  MySecureX
//
//  Created by Vitald3 on 14.07.2025.
//

import Foundation

protocol UserDefaultsStorageProtocol {
    func set<T: Codable>(_ value: T, forKey key: String)
    func get<T: Codable>(_ type: T.Type, forKey key: String) -> T?
    func remove(forKey key: String)
    func bool(forKey key: String) -> Bool
    func set(_ value: Bool, forKey key: String)
    func setArray<T: Codable>(_ value: [T], forKey key: String)
    func getArray<T: Codable>(_ type: [T].Type, forKey key: String) -> [T]?
}

final class UserDefaultsStorage: UserDefaultsStorageProtocol {
    private let defaults: UserDefaults
    
    init() {
        let bundleID = Bundle.main.bundleIdentifier ?? AppConstants.bundleId
        let groupID = "group.\(bundleID)"
        
        if let defaults = UserDefaults(suiteName: groupID) {
            self.defaults = defaults
        } else {
            self.defaults = .standard
        }
    }

    func set<T: Codable>(_ value: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key)
        }
    }

    func get<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key),
              let object = try? JSONDecoder().decode(type, from: data) else {
            return nil
        }
        return object
    }

    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }

    func bool(forKey key: String) -> Bool {
        defaults.bool(forKey: key)
    }

    func set(_ value: Bool, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    func setArray<T: Codable>(_ value: [T], forKey key: String) {
        set(value, forKey: key)
    }
    
    func getArray<T: Codable>(_ type: [T].Type, forKey key: String) -> [T]? {
        get(type, forKey: key)
    }
}
