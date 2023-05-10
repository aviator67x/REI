//
//  UserService.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import Combine
import Foundation
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
    var tokenStorageService: TokenStorageService { get }

    func logout() -> AnyPublisher<Void, UserServiceError>
    func save(user: UserDomainModel)
    func update(user: UpdateUserRequestModel) -> AnyPublisher<UpdateUserResponseModel, UserServiceError>
    func getUser() -> UserDomainModel?
    func saveAvatar(image: Data) -> AnyPublisher<Void, UserServiceError>
    func addToFavourities(houses: [String]) -> AnyPublisher<Void, UserServiceError>
}

final class UserServiceImpl: UserService {
    let tokenStorageService: TokenStorageService
    
    private(set) lazy var userPublisher = userValueSubject.eraseToAnyPublisher()
    private var userValueSubject = CurrentValueSubject<UserDomainModel?, Never>(nil)
      
    private let userNetworkService: UserNetworkService
    private let userDefaults = UserDefaults.standard

    var user: UserDomainModel? {
        userValueSubject.value
    }

    var isAuthorized: Bool {
        tokenStorageService.token != nil
    }

    init(
        tokenStorageService: TokenStorageService,
        userNetworkService: UserNetworkService
    ) {
        self.tokenStorageService = tokenStorageService
        self.userNetworkService = userNetworkService
        startUserValueSubject()
    }

    func startUserValueSubject() {
        userValueSubject.value = getUser()
    }

    func logout() -> AnyPublisher<Void, UserServiceError> {
        guard let token = tokenStorageService.token else {
            return Fail(error: UserServiceError.tokenStorage).eraseToAnyPublisher()
        }
        return userNetworkService.logOut(token: token.value)
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
            .mapError { UserServiceError.networking($0) }
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

    func saveAvatar(image: Data) -> AnyPublisher<Void, UserServiceError> {
        let multipartItems = [MultipartItem(name: "", fileName: "\(UUID().uuidString).png", data: image)]

        return userNetworkService.saveAvatar(image: multipartItems)
            .mapError { UserServiceError.networking($0) }
            .flatMap { [unowned self] avatarUrl -> AnyPublisher<UpdateUserResponseModel, UserServiceError> in
                guard let userId = user?.id else {
                   return Fail(error: UserServiceError.noUser)
                        .eraseToAnyPublisher()
                }

                let imageURL = avatarUrl.imageURL
                let updateUserRequestModel = UpdateUserRequestModel(
                    firstName: nil,
                    lastName: nil,
                    nickName: nil,
                    imageURL: imageURL,
                    id: userId
                )

                KingfisherManager.shared.retrieveImage(
                    with: Kingfisher.ImageResource(downloadURL: imageURL),
                    options: [.cacheOriginalImage],
                    completionHandler: nil
                )

               return update(user: updateUserRequestModel)
            }
            .handleEvents(receiveOutput: { [unowned self] user in
                let userModel = UserDomainModel(networkModel: user)
                save(user: userModel)
            })
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    func addToFavourities(houses: [String]) -> AnyPublisher<Void, UserServiceError> {
        let userId = self.user?.id ?? ""
        return userNetworkService.saveHouseToFavourities(houses: houses, userId: userId)
            .mapError { UserServiceError.networking($0) }
            .eraseToAnyPublisher()
    }
}

extension UserServiceImpl {
    private enum Keys: CaseIterable {
        static let token = "secure_token_key"
        static let user = "User"
    }
}
