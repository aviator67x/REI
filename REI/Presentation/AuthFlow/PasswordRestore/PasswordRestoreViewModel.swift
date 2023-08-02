//
//  PasswordRestoreViewModel.swift
//  REI
//
//  Created by User on 27.02.2023.
//

import Combine
import Foundation

final class PasswordRestoreViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<PasswordRestoreTransition, Never>()

    private let authService: AuthNetworkService

    private(set) lazy var showAlertPublisher = showAlertSubject.eraseToAnyPublisher()
    private lazy var showAlertSubject = PassthroughSubject<Void, Never>()

    private lazy var emailSubject = CurrentValueSubject<String, Never>("")

    private(set) lazy var isInputValidSubjectPublisher = isInputValidSubject.eraseToAnyPublisher()
    private lazy var isInputValidSubject = CurrentValueSubject<Bool, Never>(false)

    // MARK: - Life cycle
    init(authServicw: AuthNetworkService) {
        self.authService = authServicw

        super.init()
        setupBinding()
    }

    // MARK: - Private methods
    private func setupBinding() {
        emailSubject
            .sinkWeakly(self, receiveValue: { (self, text) in
                self.isInputValidSubject.value = text.isEmpty ? false : true
            })
            .store(in: &cancellables)
    }
}

// MARK: - Internal extension
extension PasswordRestoreViewModel {
    func restorePassword() {
        let requestModel = RestoreRequest(email: emailSubject.value)
        authService.restorePassword(requestModel)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                    self?.showAlertSubject.send()
                case .finished:
                    debugPrint("Restore password is successfully finfished")
                }
            } receiveValue: { [weak self] value in
                debugPrint("API  response for restoring password is: \(value)")
                self?.transitionSubject.send(.success)
            }
            .store(in: &cancellables)
    }

    func updateEmail(_ email: String) {
        emailSubject.value = email
    }

    func popScreen() {
        transitionSubject.send(.popScreen)
    }

    func onBackDidTap() {
        transitionSubject.send(.finishFow)
    }
}