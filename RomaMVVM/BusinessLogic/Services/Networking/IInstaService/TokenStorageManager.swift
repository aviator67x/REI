//
//  TokenStorageManager.swift
//  RomaMVVM
//
//  Created by User on 30.01.2023.
//

import Foundation
import KeychainAccess

final class TokenStorageManager {
    
    enum Constants {
        static var bearerTokenType: String = "Bearer"
        static var accessToken: String = "access token"
        static var refreshToken: String = "refresh token"
    }
    
    private static var accessToken: String = "access token"
    private static var refreshToken: String = "refresh token"
    private static let keychain = KeychainStorage()
    
    static func setAccessToken(token: String) {
        keychain.setObject(token, forKey: accessToken)
    }
    
    static func setRefreshToken(token: String) {
        keychain.setObject(token, forKey: refreshToken)
    }
    
    static func fetchAccessToken() -> String? {
        return keychain.getObject(forKey: accessToken)
    }
    
    static func fetchRefreshToken() -> String? {
        return keychain.getObject(forKey: refreshToken)
    }
    
    static func clearTokens() {
//        keychain.removeObject(forKey: accessToken)
//        keychain.removeObject(forKey: refreshToken)
//        UserAvatarFileManagerService.removeSavedImage()
//        UserDefaultsDataService.removeAllUserData()
    }
    
    static var isAutorized: Bool {
        let accesToken = TokenStorageManager.fetchAccessToken()
        return !accesToken.isNilOrEmpty
    }
}
