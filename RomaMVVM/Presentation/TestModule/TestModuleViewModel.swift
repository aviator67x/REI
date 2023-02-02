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
    
    private let instaService: InstaService

    @Published var phoneOrEmail = ""
    @Published var password = ""

    @Published var isPhoneOrEmailValid: State = .valid
    @Published var isPasswordValid: State = .invalid(errorMessage: nil)

    @Published var isInputValid = false

    init(authService: AuthService, instaService: InstaService) {
        self.authService = authService
        self.instaService = instaService
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
            .sink { [unowned self] state in
                isPasswordValid = state
            }
            .store(in: &cancellables)

        $isPhoneOrEmailValid.combineLatest($isPasswordValid)
            .map { $0 == $1 }
            .sink { [unowned self] in
                isInputValid = $0
            }
            .store(in: &cancellables)
    }

    func logInForAccessToken() {
        debugPrint(phoneOrEmail, password)
        isLoadingSubject.send(true)
            instaService.logInForAccessToken(emailOrPhone: phoneOrEmail, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.isLoadingSubject.send(false)
                    debugPrint(error.localizedDescription)
                    self?.errorSubject.send(error)
                case .finished:
                    print("successfully finished")
                }
            } receiveValue: { [weak self] token in
                print(token)
                debugPrint("token: ", token)
                TokenStorageManager.setAccessToken(token: token)
                self?.transitionSubject.send(completion: .finished)
            }
            .store (in: &cancellables)
    }

    func showForgotPassword() {
        transitionSubject.send(.forgotPassword)
    }
    
    func showSignUp() {
        transitionSubject.send(.signUp)
    }
}

