//
//  SignInViewController.swift
//  REI
//
//  Created by user on 12.02.2023.
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
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Private methods
    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .signInDidTap:
                    viewModel.logInForAccessToken()
                case .emailDidChange(let inputText):
                    viewModel.setEmail(inputText)
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
        
        viewModel.showAlertPublisher
            .sink { [unowned self] _ in
                let alert = UIAlertController(title: "Incorrect username or password", message: "Do you wnat to create an account?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Sign up", style: .default) { _ in
                    self.viewModel.showTestSignUp()
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            .store(in: &cancellables)
    }
}
