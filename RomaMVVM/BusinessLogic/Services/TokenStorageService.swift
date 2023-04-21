//
//  KeychainService.swift
//  Networking
//
//  Created by User on 02.03.2023.
//

import Foundation
import KeychainAccess

struct Token {
    let value: String
}

protocol TokenStorageService {
    var token: Token? { get }
    func saveAccessToken(token: Token)
//    func getAccessToken() -> String?
    func clearAccessToken()
}

final class TokenStorageServiceImpl: TokenStorageService {
    let keychain: Keychain
    var token: Token?
//    private let configuration: AppConfiguration
    
    init(keychain: Keychain) {
       
        self.keychain = keychain
        if let tokenValue =  keychain[Keys.token] {
            self.token = Token(value: tokenValue)
        }
    }
    
    func saveAccessToken(token: Token) {
        keychain[Keys.token] = token.value
        self.token = token
    }
    
//    func getAccessToken() -> String? {
//        keychain[Keys.token]
//    }
    
    func clearAccessToken() {
        keychain[Keys.token] = nil
        token = nil
    }
}

extension TokenStorageServiceImpl {
    private enum Keys: CaseIterable {
        static let token = "secure_token_key"
    }
}
