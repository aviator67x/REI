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

    @Published var isPhoneEmailTextFieldValid: State = .valid
    @Published var isPasswordTextFieldValid: State = .valid

    init(dogServce: DogService) {
        self.dogService = dogServce
        super.init()
    }

    func showLogin() {}

    func validateTextField(inputText: String, type: TextFieldType) {
        let validator = TextFieldValidator(type: type)
        let result = validator.validateText(text: inputText)
        if type == .phoneOrEmail {
            isPhoneEmailTextFieldValid = result
        } else if type == .password {
            isPasswordTextFieldValid = result
        }
        
//        switch result {
//        case .valid: if type == .phoneOrEmail {
//                isPhoneEmailTextFieldValid = true
//        } else if type == .password {
//                isPasswordTextFieldValid = true
//            }
//        default: if type == .phoneOrEmail {
//                isPhoneEmailTextFieldValid = false
//            } else {
//                isPasswordTextFieldValid = false
//            }
//        }
    }

    func showForgotPassword() {}
}
