//
//  TestModuleViewController.swift
//  RomaMVVM
//
//  Created by User on 16.01.2023.
//

import UIKit

final class TestModuleViewController: BaseViewController<TestModuleViewModel> {
    // MARK: - Views
    private let contentView = TestModuleView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .loginButtonDidTap:
                    viewModel.logInForAccessToken()
//                    viewModel.signUP()
                case .phoneOrEmailTextFieldChanged(let inputText):
                    viewModel.phoneOrEmail = inputText
                case .phoneOrEmailTextFieldDidReturn:
                    viewModel.logInForAccessToken()
                case .passwordTextFieldChanged(let inputText):
                    viewModel.password = inputText
                case .forgotPasswordButtonDidTap:
                    viewModel.showForgotPassword()
                case .createAccontDidTap:
                    viewModel.showTestSignUp()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isPhoneOrEmailValid
            .sink { [unowned self] state in
                var message = ""
                switch state {
                case .valid:
                    message = ""
                case .invalid(errorMessage: let errorMessage):
                    message = errorMessage ?? ""
                }
                contentView.showPhoneEmailErrorMessage(message: message)}
            .store(in: &cancellables)
        
        viewModel.$isPasswordValid
            .sink { [unowned self] state in
                var message = ""
                switch state {
                case .valid:
                    message = ""
                case .invalid(errorMessage: let errorMessage):
                    message = errorMessage ?? ""
                }
                contentView.showPasswordErrorMessage(message: message)}
            .store(in: &cancellables)
        
        viewModel.$isInputValid
            .sink { [unowned self] in contentView.setLoginButton(enabled: $0)}
            .store(in: &cancellables)
    }
}
