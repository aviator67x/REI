//
//  UserService.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import Combine
import Foundation
import KeychainAccess
import Kingfisher

enum UserServiceError: Error {
    case userDefaults
    case tokenStorage
    case networking(NetworkError)
    case noUser
}

protocol UserService {
    var user: UserDomainModel? { get }
    var userPublisher: AnyPublisher<UserDomainModel?, Never> { get }
    var isAuthorized: Bool { get }
    var token: String? { get }
    var tokenStorageService: TokenStorageService { get }

    func logout() -> AnyPublisher<Void, UserServiceError>
    func save(user: UserDomainModel)
    func update(user: UpdateUserRequestModel) -> AnyPublisher<UpdateUserResponseModel, UserServiceError>
    func getUser() -> UserDomainModel?
//    func saveAvatar(image: Data) -> AnyPublisher<UpdateUserResponseModel, UserServiceError>
}

final class UserServiceImpl: UserService {
    private var userValueSubject = CurrentValueSubject<UserDomainModel?, Never>(nil)
    private(set) lazy var userPublisher = userValueSubject.eraseToAnyPublisher()

    let tokenStorageService: TokenStorageService
    private let keychainService: KeychainService
    private let userNetworkService: UserNetworkService
    private let userDefaults = UserDefaults.standard

    var user: UserDomainModel? {
        userValueSubject.value
    }

    var isAuthorized: Bool {
        tokenStorageService.getAccessToken() != nil
    }

    var token: String? {
        tokenStorageService.getAccessToken()
    }

    init(
        tokenStorageService: TokenStorageService,
        userNetworkService: UserNetworkService,
        keychainService: KeychainService
    ) {
        self.tokenStorageService = tokenStorageService
        self.keychainService = keychainService
        self.userNetworkService = userNetworkService
        startUserValueSubject()
    }

    func startUserValueSubject() {
        userValueSubject.value = getUser()
    }

    func logout() -> AnyPublisher<Void, UserServiceError> {
        guard let token = tokenStorageService.getAccessToken() else {
            return Fail(error: UserServiceError.tokenStorage).eraseToAnyPublisher()
        }
        return userNetworkService.logOut(token: token)
            .mapError { UserServiceError.networking($0) }
            .handleEvents(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.tokenStorageService.clearAccessToken()
                    self?.userDefaults.removeObject(forKey: Keys.user)
                    debugPrint("DATA REMOVED")
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                }
            })
            .eraseToAnyPublisher()
    }

    func save(user: UserDomainModel) {
        userDefaults.encode(data: user, key: Keys.user)
        userValueSubject.send(user)
    }

    func update(user: UpdateUserRequestModel) -> AnyPublisher<UpdateUserResponseModel, UserServiceError> {
        userNetworkService.updateUser(user)
            .mapError { UserServiceError.networking($0)}
            .eraseToAnyPublisher()
    }

    func getUser() -> UserDomainModel? {
        guard let savedUser = userDefaults.object(forKey: Keys.user) as? Data,
              let user = userDefaults.decode(type: UserDomainModel.self, data: savedUser)
        else {
            return nil
        }
        return user
    }

//    func saveAvatar(image: Data) -> AnyPublisher<UpdateUserResponseModel, UserServiceError> {
//        let multipartItems = [MultipartItem(name: "", fileName: "\(UUID().uuidString).png", data: image)]
//
//        return userNetworkService.saveAvatar(image: multipartItems)
//            .flatMap { [unowned self] avatarUrl -> AnyPublisher<UpdateUserResponseModel, UserServiceError> in
//                guard let userId = user?.id else {
//                    return Fail(error: UserServiceError.noUser)
//                        .eraseToAnyPublisher()
//                }
//
//                let imageURL = avatarUrl.imageURL
//                let updateUserRequestModel = UpdateUserRequestModel(
//                    firstName: nil,
//                    lastName: nil,
//                    nickName: nil,
//                    imageURL: imageURL,
//                    id: userId
//                )
//
//                KingfisherManager.shared.retrieveImage(
//                    with: Kingfisher.ImageResource(downloadURL: imageURL), // URL(string: imageURL)!),
//                    options: [.cacheOriginalImage],
//                    completionHandler: nil
//                )
//
//               return update(user: updateUserRequestModel)
//
//            }
//            .handleEvents(receiveOutput: { [unowned self] user in
//                                let userModel = UserDomainModel(networkModel: user)
//                                save(user: userModel) })
//
//    }

//    func saveAvatar(image: Data) -> AnyPublisher<UpdateAvatarResponceModel, NetworkError> {
//        let multipartItems = [MultipartItem(name: "", fileName: "\(UUID().uuidString).png", data: image)]
//
//        return userNetworkService.saveAvatar(image: multipartItems)
//    }
}

extension UserServiceImpl {
    private enum Keys: CaseIterable {
        static let token = "secure_token_key"
        static let user = "User"
    }
}
