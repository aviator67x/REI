//
//  PasswordRestoreViewModel.swift
//  RomaMVVM
//
//  Created by User on 27.02.2023.
//

import Combine
import Foundation

final class PasswordRestoreViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<PasswordRestoreTransition, Never>()
    
    private let authService: AuthNetworkService
    
    @Published var email: String = "aviator67x@gmail.com"
    
    init(authServicw: AuthNetworkService) {
        self.authService = authServicw

        super.init()
    }
    
    func restorePassword() {
        let requestModel = RestoreRequest(email: email)
        authService.restorePassword(requestModel)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                    self?.errorSubject.send(error)
                case .finished:
                    debugPrint("Restore password is successfully finfished")
                }
            } receiveValue: { [weak self] value in
                debugPrint("API  response for restoring passwor is: \(value)")
                self?.transitionSubject.send(completion: .finished)
            }
            .store(in: &cancellables)
    }
    
}
