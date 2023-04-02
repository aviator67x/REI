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
    var userPublisher: AnyPublisher<UserDomainModel?, Never> { get }
    var isAuthorized: Bool { get }
    var token: String? { get }

    func logOut(token: String) -> AnyPublisher<Void, NetworkError>
    func logOut()
    func save(user: UserDomainModel)
    func update(user: UpdateUserRequestModel) -> AnyPublisher<UpdateUserResponseModel, NetworkError>
    func getUser() -> UserDomainModel?
    func saveAccessToken(token: String)
    func getAccessToken() -> String?
    func clearAccessToken()
    func saveAvatar(image: Data) -> AnyPublisher<UpdateAvatarResponceModel, NetworkError>
}

final class UserServiceImpl: UserService {
    private var userValueSubject = CurrentValueSubject<UserDomainModel?, Never>(nil)
    private(set) lazy var userPublisher = userValueSubject.eraseToAnyPublisher()

    private let tokenStorageService: TokenStorageService
    private let keychainService: KeychainService
    private let userNetworkService: UserNetworkService
    private let userDefaults = UserDefaults.standard

    var isAuthorized: Bool {
        tokenStorageService.getAccessToken() != nil
    }

    var token: String? {
        tokenStorageService.getAccessToken()
    }

    init(tokenStorageService: TokenStorageService, userNetworkService: UserNetworkService, keychainService: KeychainService) {
        self.tokenStorageService = tokenStorageService
        self.keychainService = keychainService
        self.userNetworkService = userNetworkService
        startUserValueSubject()
    }
    
    func startUserValueSubject() {
        userValueSubject.value = getUser()
    }

    func logOut(token: String) -> AnyPublisher<Void, NetworkError> {
        return userNetworkService.logOut(token: token)
    }
    
    func logOut() {
        clearAccessToken()
        userDefaults.removeObject(forKey: Keys.user)
    }

    func save(user: UserDomainModel) {
        userDefaults.encode(data: user, key: Keys.user)
        userValueSubject.send(user)
    }

    func update(user: UpdateUserRequestModel) -> AnyPublisher<UpdateUserResponseModel, NetworkError> {
       return userNetworkService.updateUser(user)
    }

    func getUser() -> UserDomainModel? {
        guard let savedUser = userDefaults.object(forKey: Keys.user) as? Data,
              let user = userDefaults.decode(type: UserDomainModel.self, data: savedUser)
        else { return nil
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

    func saveAvatar(image: Data) -> AnyPublisher<UpdateAvatarResponceModel, NetworkError> {
        let multipartItems = [MultipartItem(name: "", fileName: "\(UUID().uuidString).png", data: image)]

        return userNetworkService.saveAvatar(image: multipartItems)
    }
}

extension UserServiceImpl {
    private enum Keys: CaseIterable {
        static let token = "secure_token_key"
        static let user = "User"
    }
}
