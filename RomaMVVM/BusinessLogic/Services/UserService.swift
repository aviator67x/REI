//
//  UserService.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import Foundation
import KeychainAccess
import Combine

enum UserServiceError: Error {
    case userDefaults
}

protocol UserService {
    var isAuthorized: Bool { get }
    var token: String? { get }
    var userValueSubject: CurrentValueSubject<UserModel?, Never> { get set }
    
    func save(user: SignInResponse)
    func saveAccessToken(token: String)
    func clearAccessToken()
    func getUser() -> UserModel
}

final class UserServiceImpl: UserService {
    var userValueSubject = CurrentValueSubject<UserModel?, Never>(nil)
    
    var isAuthorized: Bool {
        keychainService.getObject(forKey: Keys.token) != nil
    }
    
    var token: String? {
        keychainService.getAccessToken()
    }

    private let keychainService: KeychainService

    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }
    
    func save(user: SignInResponse) {
        let userModel = UserModel(networkModel: user)
        let userDefaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userModel) {
            userDefaults.set(encoded, forKey: Keys.user)
        }
        keychainService.saveAccessToken(token: userModel.accessToken)
    }
    
    func getUser() -> UserModel {
        let userDefaults = UserDefaults.standard
        let decoder = JSONDecoder()
        guard let savedUser = userDefaults.object(forKey: Keys.user) as? Data,
              let user = try? decoder.decode(UserModel.self, from: savedUser) else {fatalError()}
                return user
    }
    
    func saveAccessToken(token: String) {
        keychainService.saveAccessToken(token: token)
    }
    
    func clearAccessToken() {
        keychainService.clearAccessToken()
    }
}
extension UserServiceImpl {
    private enum Keys: CaseIterable {
        static let token = "secure_token_key"
        static let user = "User"
    }
}
