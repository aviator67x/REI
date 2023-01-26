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
    private let validator = TextFieldValidator()
    
    init(dogServce: DogService) {
        self.dogService = dogServce
        super.init()
    }
    
    func showLogin() {}
    
    func validateTextField(inputText: String, type: TextFieldType) {
        print("State is \(validator.validateText(text: inputText, type: type))")
    }
    
    func showForgotPassword() {}
}
