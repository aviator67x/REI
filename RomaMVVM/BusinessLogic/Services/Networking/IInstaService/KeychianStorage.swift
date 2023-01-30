//
//  KeychianStorage.swift
//  RomaMVVM
//
//  Created by User on 30.01.2023.
//

import Foundation
import KeychainAccess

// MARK: - KeychainSavable Protocol
protocol KeychainSavable {
    func setObject(_ object: String, forKey: String)
    func getObject(forKey: String) -> String?
    func removeObject(forKey: String)
}

// MARK: - KeychainStorage
final class KeychainStorage: KeychainSavable {
    // MARK: - Private properties
    private static let bundleID: String = "com.andreymomot.NetworkingLayer"
    private let keychain = Keychain(service: bundleID)
    
    // MARK: - Set object
    func setObject(_ object: String, forKey: String) {
        keychain[forKey] = object
    }
    
    // MARK: - Get object
    func getObject(forKey: String) -> String? {
        return keychain[forKey]
    }
    
    // MARK: - Remove object
    func removeObject(forKey: String) {
        do {
            try keychain.remove(forKey)
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

