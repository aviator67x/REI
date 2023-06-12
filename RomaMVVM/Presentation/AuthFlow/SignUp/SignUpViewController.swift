//
//  TestSignUpModuleViewController.swift
//  RomaMVVM
//
//  Created by User on 03.02.2023.
//

import UIKit

final class SignUpViewController: BaseViewController<SignUpViewModel> {
    // MARK: - Views
    private let contentView = SignUpView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        navigationItem.setHidesBackButton(true, animated: true)
        setupBindings()
        super.viewDidLoad()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .nameDidChange(let text):
                    viewModel.name = text

                case .emailDidChange(let text):
                    viewModel.email = text

                case .passwordDidChange(let text):
                    viewModel.password = text

                case .confirmPasswordDidChange(let text):
                    viewModel.confirmPassword = text

                case .signUpDidTap:
                    viewModel.signUp()
                    
                case .crossDidTap:
                    viewModel.popScreen()
                }
            }
            .store(in: &cancellables)
        
        viewModel.isNameValid
            .sink { [unowned self] state in
                var message = ""
                switch state {
                case .valid:
                    message = ""
                case .invalid(errorMessage: let errorMessage):
                    message = errorMessage ?? ""
                }
                contentView.showNameErrorMessage(message: message)
            }
            .store(in: &cancellables)
        
        viewModel.isEmailValid
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
        
        viewModel.isPasswordValid
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
            .sink { [unowned self] isValid in
                contentView.setSignUpButton(enabled: isValid)
            }
            .store(in: &cancellables)
        
        viewModel.showAlertPublisher
            .sink { [unowned self] _ in
                let alert = UIAlertController(title: "This Email already exists", message: "Please, creare a new one", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            .store(in: &cancellables)
    }
}
