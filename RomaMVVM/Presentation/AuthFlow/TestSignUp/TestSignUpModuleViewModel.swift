//
//  TestSignUpModuleViewModel.swift
//  RomaMVVM
//
//  Created by User on 03.02.2023.
//

import Combine
import Foundation

final class TestSignUpModuleViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<TestSignUpModuleTransition, Never>()
    
    private let authService: AuthNetworkService
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published private(set) var isInputValid: Bool = true
    
    init(authService: AuthNetworkService) {
        self.authService = authService
        
        super.init()
    }
    
    func signUp() {
        let requestModel = SignUpRequest(name: "Bluberry", email: "bluberry@mail.co", password: "tasty")
        isLoadingSubject.send(true)
       authService.signUp(requestModel)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("SignUp is successfully finished")
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.errorSubject.send(error)
                }
            } receiveValue: { [weak self] signUpInfo in
                debugPrint("signUpInfo", signUpInfo.name)
                self?.transitionSubject.send(completion: .finished)
            }
            .store(in: &cancellables)
    }
    
}
