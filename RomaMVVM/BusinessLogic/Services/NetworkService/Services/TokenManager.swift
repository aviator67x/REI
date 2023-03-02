//
//  TokenManager.swift
//  Services
//
//  Created by User on 02.03.2023.
//

import Foundation
import KeychainAccess

final class TokenManager {
    private let keychainService: KeychainService

    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }

    func setAccessToken(token: String) {
        keychainService.saveObject(token, forKey: Keys.accessToken)
    }

    func setRefreshToken(token: String) {
        keychainService.saveObject(token, forKey: Keys.refreshToken)
    }

    func fetchAccessToken() -> String? {
        return keychainService.getObject(forKey: Keys.accessToken)
    }

    func fetchRefreshToken() -> String? {
        return keychainService.getObject(forKey: Keys.refreshToken)
    }

    func clearTokens() {
        keychainService.clearObject(forKey: Keys.accessToken)
        keychainService.clearObject(forKey: Keys.refreshToken)
    }

    var isAutorized: Bool {
        let accesToken = fetchAccessToken()
        return !accesToken.isNilOrEmpty
    }
}

extension TokenManager {
    private enum Keys: CaseIterable {
        static let accessToken = "access token"
        static let refreshToken = "refresh token"
    }
}
