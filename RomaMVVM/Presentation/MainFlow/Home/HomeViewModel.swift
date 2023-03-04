//
//  HomeViewModel.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 20.11.2021.
//

import Combine
import CombineNetworking
import Foundation

final class HomeViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<HomeTransition, Never>()
    
    private(set) lazy var userPublisher = userSubject.eraseToAnyPublisher()
    private let userSubject = CurrentValueSubject<UserModel?, Never>(nil)

    private let userService: UserService

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
                guard let userModel =  userModel else { return }
                self?.userSubject.send(userModel)
            }
            .store(in: &cancellables)
    }
}
