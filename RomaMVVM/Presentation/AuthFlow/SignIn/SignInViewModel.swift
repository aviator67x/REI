//
//  SignInViewModel.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 12.12.2021.
//

import Combine
import Foundation

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

    init(
        authService: AuthNetworkService,
        userService: UserService
    ) {
        self.authService = authService
        self.userService = userService

        super.init()
    }

    override func onViewDidLoad() {
        emailSubject
            .map { login in
                TextFieldValidator(type: .email).validateText(text: login)
            }
            .sink { [unowned self] state in
                isEmailValid = state
            }
            .store(in: &cancellables)

        $password
            .map { password in TextFieldValidator(type: .password).validateText(text: password) }
            .sink { [unowned self] state in
                isPasswordValid = state
            }
            .store(in: &cancellables)

        $isEmailValid.combineLatest($isPasswordValid)
            .map {
                ($0 == .valid) && ($1 == .valid)
            }
            .sink { [unowned self] in
                isInputValid = true
//                isInputValid = $0
            }
            .store(in: &cancellables)
    }

    func setEmail(_ text: String) {
        emailSubject.send(text)
    }

    func logInForAccessToken() {
        let requestModel = SignInRequest(login: emailSubject.value, password: password)
        isLoadingSubject.send(true)
        authService.signIn(requestModel)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                    self?.errorSubject.send(error)
                case .finished:
                    debugPrint("SignIn is successfully finished")
                }
            } receiveValue: { [weak self] user in
                self?.isLoadingSubject.send(false)
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
