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
    var email: String? { get }
    var name: String? { get }
    var userId: String? { get }
    var userValueSubject: CurrentValueSubject<UserModel?, Never> { get set }
    
    func save(user: SignInResponse)
    func saveAccessToken(token: String)
    func clearAccessToken()
    func getUser() -> UserModel
}

final class UserServiceImpl: UserService {
    var userValueSubject = CurrentValueSubject<UserModel?, Never>(nil)
    
    var isAuthorized: Bool {
        keychain[Keys.token] != nil
    }
    
    var token: String? {
        keychain[Keys.token]
    }
    
    var email: String? {
        getUser().email
    }
    
    var name: String? {
        getUser().name
    }
    
    var userId: String? {
        getUser().id
    }
    
    private let keychain: Keychain
    private let configuration: AppConfiguration
    
    init(configuration: AppConfiguration) {
        self.configuration = configuration
        self.keychain = Keychain(service: configuration.bundleId)
    }
    
    func save(user: SignInResponse) {
        let userModel = UserModel(networkModel: user)
        let userDefaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userModel) {
            userDefaults.set(encoded, forKey: "User")
        }
        
        keychain[Keys.token] = userModel.accessToken
    }
    
    func getUser() -> UserModel {
        let userDefaults = UserDefaults.standard
        let decoder = JSONDecoder()
        guard let savedUser = userDefaults.object(forKey: "User") as? Data,
              let user = try? decoder.decode(UserModel.self, from: savedUser) else {fatalError()}
                return user
    }
    
    func saveAccessToken(token: String) {
        keychain[Keys.token] = token
    }
    
    func clearAccessToken() {
        keychain[Keys.token] = nil
    }
}
extension UserServiceImpl {
    private enum Keys: CaseIterable {
        static let token = "secure_token_key"
        static let email = "secure_email_key"
        static let name = "secure_name_key"
        static let userId = "secure_userId_key"
    }
}
