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
