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
}

protocol UserService {
    var user: UserDomainModel? { get }
    var userPublisher: AnyPublisher<UserDomainModel?, Never> { get }
    var isAuthorized: Bool { get }
    var token: String? { get }
    var tokenStorageService: TokenStorageService { get }

    func logout() -> AnyPublisher<Void, UserServiceError>
    func save(user: UserDomainModel)
    func update(user: UpdateUserRequestModel) -> AnyPublisher<UpdateUserResponseModel, NetworkError>
    func getUser() -> UserDomainModel?
    func saveAvatar(image: Data) -> AnyPublisher<UpdateAvatarResponceModel, NetworkError>
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

    init(tokenStorageService: TokenStorageService, userNetworkService: UserNetworkService, keychainService: KeychainService) {
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
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            })
            .eraseToAnyPublisher()
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
        else {
            return nil
        }
        return user
    }
    
//    func saveAvatar(image: Data) -> AnyPublisher<UpdateUserResponseModel, NetworkError> {
//        let multipartItems = [MultipartItem(name: "", fileName: "\(UUID().uuidString).png", data: image)]
//
//        return userNetworkService.saveAvatar(image: multipartItems)
//            .mapError { UserServiceError.networking($0) }
//            .flatMap { (UpdateAvatarResponceModel, NetworkError) -> (UpdateUserResponseModel, NetworkError) value in
//
//            }
////            .eraseToAnyPublisher()
//    }
    
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished: print("Finished")
//                case .failure(let error): debugPrint(error.errorDescription ?? "")
//                }
//            }, receiveValue: { avatar in
//                let imageURL = avatar.imageURL
//                let userId = self.user?.id ?? ""
//                let updateUserRequestModel = UpdateUserRequestModel(
//                    firstName: nil,
//                    lastName: nil,
//                    nickName: nil,
//                    imageURL: imageURL,
//                    id: userId
//                )
//                KingfisherManager.shared.retrieveImage(
//                    with: Kingfisher.ImageResource(downloadURL: URL(string: imageURL)!),
//                    options: [.cacheOriginalImage],
//                    completionHandler: nil)
//                self.update(user: updateUserRequestModel)
//            })
//    }

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
