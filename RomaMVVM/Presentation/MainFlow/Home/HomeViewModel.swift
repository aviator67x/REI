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
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<HomeTransition, Never>()

    private(set) lazy var userPublisher = userSubject.eraseToAnyPublisher()
    private let userSubject = CurrentValueSubject<UserModel?, Never>(nil)

    private let imageSubject = CurrentValueSubject<Data?, Never>(nil)
    
//    @Published var images: [UIImage] = []


    private let userService: UserService

    private let avatar = UIImage(named: "girl") ?? UIImage()

    init(userService: UserService) {
        self.userService = userService
        super.init()
    }

    override func onViewDidLoad() {
        super.onViewDidLoad()

        getUser()
    }

    func getUser() {
        userService.userPublisher
            .sink { [weak self] userModel in
                guard let userModel = userModel else { return }
                self?.userSubject.send(userModel)
            }
            .store(in: &cancellables)
    }

    func saveAvatar() {
        guard let imageData = imageSubject.value else { return }
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
                print(avatarUrlDict["fileURL"] ?? "")
            }
            .store(in: &cancellables)
    }
    
    func updateImageSubject(with imageData: Data) {
        imageSubject.value = imageData
    }
}
