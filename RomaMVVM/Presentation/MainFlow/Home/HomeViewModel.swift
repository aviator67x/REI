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
    
    func logOut() {
        isLoadingSubject.send(true)
        userService.logoutCorrect()
            .receive(on: DispatchQueue.main)
            .print("logout viewmodel")
            .sink { [unowned self] completion in
                isLoadingSubject.send(false)
                if case .failure(let error) = completion {
                    errorSubject.send(error)
                }
            } receiveValue: { [unowned self] _ in
                transitionSubject.send(.logout)
            }
            .store(in: &cancellables)

//        guard let token = userService.token else {
//            return
//        }
//        userService.logOut(token: token)
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] completion in
//                switch completion {
//                case .finished:
//                    self?.transitionSubject.send(.logout)
//                case let .failure(error):
//                    debugPrint(error.localizedDescription)
//                    self?.errorSubject.send(error)
//                }
//            } receiveValue: { _ in
//                self.userService.logOut()
//                self.transitionSubject.send(.logout)
//                self.transitionSubject.send(completion: .finished)
//            }
//            .store(in: &cancellables)
    }


    func updateUniversalImageSubject(with resource: ImageResource) {
        universalImageSubject.value = resource
    }
}
