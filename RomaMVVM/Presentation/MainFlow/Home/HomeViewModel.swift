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
    private let userSubject = PassthroughSubject<UserModel, Never>()
    
    private(set) var userValueSubject = CurrentValueSubject<UserModel?, Never>(nil)

    private let userService: UserService

    init(userService: UserService) {
        self.userService = userService
        super.init()
    }

    override func onViewDidLoad() {
        super.onViewDidLoad()
        let user = userService.getUser(for: "User")
//        userSubject.send(user)
        userValueSubject.send(user)
    }

    func showDetail(for dog: DogResponseModel) {
        debugPrint("show detail for ", dog)
    }
}
