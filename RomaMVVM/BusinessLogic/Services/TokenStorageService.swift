//
//  KeychainService.swift
//  Networking
//
//  Created by User on 02.03.2023.
//

import Foundation
import KeychainAccess

protocol TokenStorageService {
    var keychain: Keychain { get }
    
    func saveAccessToken(token: String)
    func getAccessToken() -> String?
    func clearAccessToken()
}

final class TokenStorageServiceImpl: TokenStorageService {
    let keychain: Keychain
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
}

extension TokenStorageServiceImpl {
    private enum Keys: CaseIterable {
        static let token = "secure_token_key"
    }
}
