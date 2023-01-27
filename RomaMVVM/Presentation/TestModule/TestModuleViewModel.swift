//
//  TestModuleViewModel.swift
//  RomaMVVM
//
//  Created by User on 16.01.2023.
//

import Combine

final class TestModuleViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<TestModuleTransition, Never>()
    private let dogService: DogService
    
    @Published var isTextFieldValid: Bool = false
    
    init(dogServce: DogService) {
        self.dogService = dogServce
        super.init()
    }
    
    func showLogin() {}
    
    func validateTextField(inputText: String, type: TextFieldType) {
        let validator = TextFieldValidator(type: type)
        let result = validator.validateText(text: inputText)
//        print("State is \(String(describing: validator.validateText(text: inputText)))")
        switch result {
        case .valid: isTextFieldValid = true
        default: isTextFieldValid = false
        }
    }
    
    func showForgotPassword() {}
}
