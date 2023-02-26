//
//  SignInViewController.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 12.12.2021.
//

import UIKit

final class SignInViewController: BaseViewController<SignInViewModel> {
    // MARK: - Views
    private let contentView = SignInView()
    
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
                case .signInDidTap:
                    viewModel.logInForAccessToken()
//                    viewModel.signUP()
                case .emailDidChange(let inputText):
                    viewModel.email = inputText
                case .phoneOrEmailTextFieldDidReturn:
                    viewModel.logInForAccessToken()
                case .passwordDidChange(let inputText):
                    viewModel.password = inputText
                case .forgotPasswordButtonDidTap:
                    viewModel.showForgotPassword()
                case .createAccontDidTap:
                    viewModel.showTestSignUp()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isEmailValid
            .sink { [unowned self] state in
                var message = ""
                switch state {
                case .valid:
                    message = ""
                case .invalid(errorMessage: let errorMessage):
                    message = errorMessage ?? ""
                }
                contentView.showEmailErrorMessage(message: message)}
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
            .sink { [unowned self] in contentView.setSignInButton(enabled: $0)}
            .store(in: &cancellables)
    }
}
