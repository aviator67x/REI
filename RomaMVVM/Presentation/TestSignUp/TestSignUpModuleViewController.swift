//
//  TestSignUpModuleViewController.swift
//  RomaMVVM
//
//  Created by User on 03.02.2023.
//

import UIKit

final class TestSignUpModuleViewController: BaseViewController<TestSignUpModuleViewModel> {
    // MARK: - Views
    private let contentView = TestSignUpModuleView()

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
                case .signUpDidTap:
                    viewModel.signUp()
                }
            }
            .store(in: &cancellables)

        viewModel.$isInputValid
            .sink { [unowned self] in
                self.contentView.setSignUpButton(enabled: $0)
        }
            .store(in: &cancellables)
    }
}
