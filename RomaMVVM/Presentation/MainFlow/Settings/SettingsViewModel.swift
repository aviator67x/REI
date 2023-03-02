//
//  SettingsViewModel.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import Combine
import Foundation

final class SettingsViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SettingsTransition, Never>()
    
    private let userService: UserService
    private let userNetworkService: UserNetworkService
    
    init(userService: UserService, userNerworkService: UserNetworkService) {
        self.userService = userService
        self.userNetworkService = userNerworkService
        super.init()
    }
    
    func logout() {
        guard let token = userService.token else { return }
//        userService.clear()
        userNetworkService.logOut(token: token)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.transitionSubject.send(.logout)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    self?.errorSubject.send(error)
                }
            } receiveValue: { _ in
//                self.transitionSubject.send(completion: .finished)//
                self.transitionSubject.send(.logout)
            }
            .store(in: &cancellables)

        
    }
}
