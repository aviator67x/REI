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
        setupBindings()
        super.viewDidLoad()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .nameChanged(let text):
                    viewModel.name = text

                case .emailChanged(let text):
                    viewModel.email = text

                case .passwordChanged(let text):
                    viewModel.password = text

                case .confirmPasswordChanged(let text):
                    viewModel.confirmPassword = text

                case .doneTapped:
                    viewModel.signUp()
                }
            }
            .store(in: &cancellables)

        viewModel.$isInputValid
            .sink { [unowned self] isValid in
                contentView.setDoneButton(enabled: isValid)
            }
            .store(in: &cancellables)
    }
}
