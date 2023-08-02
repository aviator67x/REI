//
//  SignInViewModel.swift
//  REI
//
//  Created by user on 12.02.2023.
//

import Combine
import Foundation
import UIKit

final class SignInViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SignInTransition, Never>()

    private let authService: AuthNetworkService
    private var userService: UserService

    private let emailSubject = CurrentValueSubject<String, Never>("")

    @Published var password = ""

    @Published var isEmailValid: State = .invalid(errorMessage: nil)
    @Published var isPasswordValid: State = .invalid(errorMessage: nil)

    @Published private(set) var isInputValid = false

    private(set) lazy var showAlertPublisher = showAlertSubject.eraseToAnyPublisher()
    private lazy var showAlertSubject = PassthroughSubject<Void, Never>()

    // MARK: - Life cycle
    init(
        authService: AuthNetworkService,
        userService: UserService
    ) {
        self.authService = authService
        self.userService = userService

        super.init()
    }

    override func onViewDidLoad() {
        setupBinding()
    }

    // MARK: - Private methods
    private func setupBinding() {
        emailSubject
            .dropFirst()
            .map { login in
                TextFieldValidator(type: .email).validateText(text: login)
            }
            .sink { [unowned self] state in
                isEmailValid = state
            }
            .store(in: &cancellables)

        $password
            //            .map { password in TextFieldValidator(type: .password).validateText(text: password) }
            .dropFirst()
            .map { $0.count > 8 }
            .sink { [unowned self] state in
                isPasswordValid = state ? .valid : .invalid(errorMessage: "Password doesn't meet minimal requirements")
            }
            .store(in: &cancellables)

        $isEmailValid.combineLatest($isPasswordValid)
            .dropFirst()
            .map {
                ($0 == .valid) && ($1 == .valid)
            }
            .sink { [unowned self] in
                isInputValid = $0
            }
            .store(in: &cancellables)
    }
}

// MARK: - Internal extension
extension SignInViewModel {
    func setEmail(_ text: String) {
        emailSubject.send(text)
    }

    func logInForAccessToken() {
        let requestModel = SignInRequest(login: emailSubject.value, password: password)
        isLoadingSubject.send(true)
        authService.signIn(requestModel)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingSubject.send(false)
                switch completion {
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                    self?.showAlertSubject.send()
                case .finished:
                    debugPrint("SignIn is successfully finished")
                }
            } receiveValue: { [weak self] user in
                let userModel = UserDomainModel(networkModel: user)
                let token = user.accessToken
                self?.userService.save(user: userModel)
                self?.userService.tokenStorageService.saveAccessToken(token: Token(value: token))
                self?.transitionSubject.send(.success)
                self?.transitionSubject.send(completion: .finished)
            }
            .store(in: &cancellables)
    }

    func showForgotPassword() {
        transitionSubject.send(.forgotPassword)
    }

    func showTestSignUp() {
        transitionSubject.send(.signUp)
    }
}
