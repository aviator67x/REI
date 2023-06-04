//
//  SignUpViewModel.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 12.12.2021.
//

import Combine
import Foundation

final class SignUpViewModel: BaseViewModel {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    var isNameValid = CurrentValueSubject<State, Never>(.invalid(errorMessage: ""))
    var isEmailValid = CurrentValueSubject<State, Never>(.invalid(errorMessage: ""))
    var isPasswordValid = CurrentValueSubject<State, Never>(.invalid(errorMessage: ""))
    @Published var isInputValid = false

    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SignUpTransition, Never>()

    private let authService: AuthNetworkService
    private let userService: UserService

    init(authService: AuthNetworkService, userService: UserService) {
        self.authService = authService
        self.userService = userService

        super.init()
    }

    override func onViewDidLoad() {
        $name
            .dropFirst(2)
            .map { name in
                TextFieldValidator(type: .fullName).validateText(text: name)
            }
            .sink { [unowned self] state in
                isNameValid.value = state
            }
            .store(in: &cancellables)

        $email
            .dropFirst(2)
            .map { email in
                TextFieldValidator(type: .email).validateText(text: email)
            }
            .sink { [unowned self] state in
                isEmailValid.value = state
            }
            .store(in: &cancellables)

        $password
            .dropFirst(2)
            .map { password in
                TextFieldValidator(type: .password).validateText(text: password)
            }
            .sink { [unowned self] state in
                isPasswordValid.value = state
            }
            .store(in: &cancellables)

//        $name.combineLatest($email, $password, $confirmPassword)
//            .map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty && !$0.3.isEmpty }
//            .sink { [unowned self] in isInputValid = $0 }
//            .store(in: &cancellables)
        
        isNameValid.combineLatest(isEmailValid, isPasswordValid)
            .map { _ in self.isNameValid.value == .valid && self.isEmailValid.value == .valid && self.isPasswordValid.value == .valid }
            .sink { [unowned self] in isInputValid = $0}
            .store(in: &cancellables)
    }

    func signUp() {
        let requestModel = SignUpRequest(name: name, email: email, password: password)
        isLoadingSubject.send(true)
        authService.signUp(requestModel)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("SignUp is successfully finished")
                    self?.isLoadingSubject.send(false)
                case let .failure(error):
                    print(error.localizedDescription)
                    self?.errorSubject.send(error)
                }
            } receiveValue: { [weak self] signUpInfo in
                debugPrint("signUpInfo", signUpInfo.name)
                guard let self = self else { return }
                let requestModel = SignInRequest(
                    login: self.email,
                    password: self.password
                )
                self.signIn(requestModel: requestModel)
            }
            .store(in: &cancellables)
    }

    private func signIn(requestModel: SignInRequest) {
        authService.signIn(requestModel)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("SignIn is successfully finished")
                    self?.isLoadingSubject.send(false)
                case let .failure(error):
                    print(error.localizedDescription)
                    self?.errorSubject.send(error)
                }
            } receiveValue: { [weak self] signinResponse in
                let userModel = UserDomainModel(networkModel: signinResponse)
                let token = signinResponse.accessToken
                self?.userService.save(user: userModel)
                self?.userService.tokenStorageService.saveAccessToken(token: Token(value: token))
                self?.transitionSubject.send(.success)
                self?.transitionSubject.send(completion: .finished)
            }
            .store(in: &cancellables)
    }
    
    func popScreen() {
        transitionSubject.send(.popScreen)
    }
}
