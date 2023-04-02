//
//  HomeViewModel.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 20.11.2021.
//

import Combine
import CombineNetworking
import Foundation
import Photos
import UIKit

final class HomeViewModel: BaseViewModel {
    // MARK: - Private properties
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<HomeTransition, Never>()

    private(set) lazy var userPublisher = userSubject.eraseToAnyPublisher()
    private let userSubject = CurrentValueSubject<UserDomainModel?, Never>(nil)

    private(set) lazy var showPhotoPublisher = showPhotoSubject.eraseToAnyPublisher()
    private let showPhotoSubject = CurrentValueSubject<Bool, Never>(false)

    private(set) lazy var universalImagePublisher = universalImageSubject.eraseToAnyPublisher()
    private let universalImageSubject = CurrentValueSubject<ImageResource?, Never>(nil)

    private let userService: UserService

    // MARK: - Lifecycle
    init(userService: UserService) {
        self.userService = userService
        super.init()
    }

    override func onViewDidLoad() {
        super.onViewDidLoad()

        getUser()
    }
}

// MARK: - extension
extension HomeViewModel {
    func getUser() {
        userService.userPublisher
            .sink { [weak self] userModel in
                guard let userModel = userModel else { return }
                self?.userSubject.send(userModel)
            }
            .store(in: &cancellables)
    }

    func showGallery() {
        showPhotoSubject.value = true
    }

    func saveAvatar() {
        var imageData = Data()
        let imageValue = universalImageSubject.value
        switch imageValue {
        case let .imageData(data):
            imageData = data
        case .some(.imageURL(_)):
            break
        case let .some(.imageAsset(asset)):
            if let data = asset.image.pngData() {
                imageData = data
            }
        case .none:
            break
        }
        userService.saveAvatar(image: imageData)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    print("Avatar has been saved")
                case let .failure(error):
                    print(error.errorDescription ?? "")
                }
            } receiveValue: { [unowned self] avatarUrlDict in
                let imageURL = avatarUrlDict.imageURL
                let userId = userService.getUser()?.id ?? ""
                let updateUserRequestModel = UpdateUserRequestModel(imageURL: imageURL, id: userId)
                update(user: updateUserRequestModel)
            }
            .store(in: &cancellables)
    }

   private func update(user: UpdateUserRequestModel) {
        userService.update(user: user)
           .receive(on: DispatchQueue.main)
           .sink{ [unowned self] completion in
               switch completion {
               case .finished:
                   print("User has been updated")
               case .failure(let error):
                   errorSubject.send(error)
               }
           } receiveValue: { [unowned self] user in
               let userModel = UserDomainModel(networkModel: user)
               self.userService.save(user: userModel)
           }
           .store(in: &cancellables)
    }

    func updateUniversalImageSubject(with resource: ImageResource) {
        switch resource {
        case let .imageURL(url):
            universalImageSubject.value = .imageURL(url)
        case let .imageData(data):
            universalImageSubject.value = .imageData(data)
        case let .imageAsset(imageAsset):
            universalImageSubject.value = .imageAsset(imageAsset)
        }
    }
}
