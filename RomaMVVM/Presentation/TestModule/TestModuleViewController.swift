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
                    viewModel.showLogin()
                case .phoneOrEmailTextFieldChanged(let inputText):
                    viewModel.validateTextField(inputText: inputText, type: .phoneOrEmail)
                case .passwordTextFieldChanged(let inputText):
                    viewModel.validateTextField(inputText: inputText, type: .password)
                case .forgotPasswordButtonDidTap:
                    viewModel.showForgotPassword()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isTextFieldValid
            .sink { [unowned self] value in contentView.showErrorMessage()}
            .store(in: &cancellables)
    }
}
