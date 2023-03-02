//
//  KeychainService.swift
//  Networking
//
//  Created by User on 02.03.2023.
//

import Foundation
import KeychainAccess

protocol KeychainService {
    func saveAccessToken(token: String)
    func getAccessToken() -> String?
    func clearAccessToken()
    func saveObject(_ object: String, forKey: String)
    func getObject(forKey: String) -> String?
    func clearObject(forKey: String)
}

final class KeychainServiceImpl: KeychainService {
    private let keychain: Keychain
    private let configuration: AppConfiguration
    
    init(configuration: AppConfiguration) {
        self.configuration = configuration
        self.keychain = Keychain(service: configuration.bundleId)
    }
    
    func saveAccessToken(token: String) {
        keychain[Keys.token] = token
    }
    
    func getAccessToken() -> String? {
        keychain[Keys.token]
    }
    
    func clearAccessToken() {
        keychain[Keys.token] = nil
    }

    func saveObject(_ object: String, forKey: String) {
        keychain[forKey] = object
    }

    func getObject(forKey: String) -> String? {
        return keychain[forKey]
    }

    func clearObject(forKey: String) {
        do {
            try keychain.remove(forKey)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension KeychainServiceImpl {
    private enum Keys: CaseIterable {
        static let token = "secure_token_key"
    }
}
