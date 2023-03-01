//
//  SignUpViewModel.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 12.12.2021.
//

import Combine
import Foundation

final class SignUpViewModel: BaseViewModel {
    @Published var name: String = "Bluberry"
    @Published var email: String = "bluberry@mail.co"
    @Published var password: String = "tasty"
    @Published var confirmPassword: String = "tasty"
    @Published var isInputValid: Bool = false

    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SignUpTransition, Never>()
    
    private let authService: AuthNetworkService
    
    init(authService: AuthNetworkService) {
        self.authService = authService
        
        super.init()
    }

    override func onViewDidLoad() {
        $name.combineLatest($email, $password, $confirmPassword)
            .map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty && !$0.3.isEmpty }
            .sink { [unowned self] in isInputValid = $0 }
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
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.errorSubject.send(error)
                }
            } receiveValue: { [weak self] signUpInfo in
                debugPrint("signUpInfo", signUpInfo.name)
                self?.transitionSubject.send(.success)
                self?.transitionSubject.send(completion: .finished)
            }
            .store(in: &cancellables)
    }

//    func signUpUser() {
//        transitionSubject.send(.success)
//    }
}
