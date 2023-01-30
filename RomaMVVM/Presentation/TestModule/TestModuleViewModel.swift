//
//  TestModuleViewModel.swift
//  RomaMVVM
//
//  Created by User on 16.01.2023.
//

import Combine
import Foundation

final class TestModuleViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<TestModuleTransition, Never>()
    private let authService: AuthService

    @Published var phoneOrEmail = ""
    @Published var password = ""

    @Published var isPhoneOrEmailValid: State = .valid
    @Published var isPasswordValid: State = .valid

    @Published var isInputValid = false

    init(authService: AuthService) {
        self.authService = authService
        super.init()
    }

    override func onViewDidLoad() {
        $phoneOrEmail
            .map { login in TextFieldValidator(type: .phoneOrEmail).validateText(text: login) }
            .sink { [unowned self] state in
                isPhoneOrEmailValid = state
            }
            .store(in: &cancellables)

        $password
            .map { password in TextFieldValidator(type: .password).validateText(text: password) }
            .sink { [unowned self] state in isPasswordValid = state }
            .store(in: &cancellables)

        $isPhoneOrEmailValid.combineLatest($isPasswordValid)
            .map { $0 == $1 }
            .sink { [unowned self] in isInputValid = $0 }
            .store(in: &cancellables)
    }

    func saveLogin(login: String) {
        phoneOrEmail = login
    }

    func savePassword(password: String) {
        self.password = password
    }

    func showLogin() {}
    func logIn() {}

    func showForgotPassword() {}
}
