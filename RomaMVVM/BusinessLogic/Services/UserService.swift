//
//  UserService.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import Combine
import Foundation
import KeychainAccess

enum UserServiceError: Error {
    case userDefaults
    case tokenStorage
}

protocol UserService {
    var userPublisher: AnyPublisher<UserModel?, Never> { get }
    var isAuthorized: Bool { get }
    var token: String? { get }

    func logOut(token: String) -> AnyPublisher<Void, NetworkError>
    func save(user: SignInResponse)
    func getUser() -> UserModel?
    func saveAccessToken(token: String)
    func getAccessToken() -> String?
    func clearAccessToken()
    func saveObjectToKeychain(_ object: String, forKey: String)
    func getObjectFromKeychain(forKey: String) -> String?
    func clearObjectInKeychain (forKey: String)
}

final class UserServiceImpl: UserService {
    private var userValueSubject = CurrentValueSubject<UserModel?, Never>(nil)
    private(set) lazy var userPublisher = userValueSubject.eraseToAnyPublisher()
    
    private let tokenStorageService: TokenStorageService
    private let keychain: Keychain
    private let userNetworkService: UserNetworkService
    private let userDefaults = UserDefaults.standard

    var isAuthorized: Bool {
        tokenStorageService.getAccessToken() != nil
    }

    var token: String? {
        tokenStorageService.getAccessToken()
    }

    init(tokenStorageService: TokenStorageService, userNetworkService: UserNetworkService) {
        self.tokenStorageService = tokenStorageService
        self.keychain = tokenStorageService.keychain
        self.userNetworkService = userNetworkService
    }
    
    func logOut(token: String) -> AnyPublisher<Void, NetworkError> {
        clearAccessToken()
        userDefaults.removeObject(forKey: Keys.user)
        return userNetworkService.logOut(token: token)
    }

    func save(user: SignInResponse) {
        let userModel = UserModel(networkModel: user)
        userDefaults.encode(data: userModel, key: Keys.user)
        tokenStorageService.saveAccessToken(token: userModel.accessToken)
        userValueSubject.send(userModel)
    }

    func getUser() -> UserModel? {
        guard let savedUser = userDefaults.object(forKey: Keys.user) as? Data,
              let user = userDefaults.decode(type: UserModel.self, data: savedUser) else { return nil
        }
        return user
    }

    func saveAccessToken(token: String) {
        tokenStorageService.saveAccessToken(token: token)
    }
    
    func getAccessToken() -> String? {
       return tokenStorageService.getAccessToken()
    }

    func clearAccessToken() {
        tokenStorageService.clearAccessToken()
    }
    
    func saveObjectToKeychain(_ object: String, forKey: String) {
        keychain[forKey] = object
    }

    func getObjectFromKeychain(forKey: String) -> String? {
        return keychain[forKey]
    }

    func clearObjectInKeychain (forKey: String) {
        do {
            try keychain.remove(forKey)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension UserServiceImpl {
    private enum Keys: CaseIterable {
        static let token = "secure_token_key"
        static let user = "User"
    }
}
