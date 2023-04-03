//
//  PasswordRestoreViewController.swift
//  RomaMVVM
//
//  Created by User on 27.02.2023.
//

import UIKit

final class PasswordRestoreViewController: BaseViewController<PasswordRestoreViewModel> {
    // MARK: - Views
    private let contentView = PasswordRestoreView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Restore password"
        setupBindings()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .restoreDidTap:
                    viewModel.restorePassword()
                case .emailTextFieldDidChange(inputText: let inputText):
                    viewModel.email = inputText
                }
            }
            .store(in: &cancellables)
    }
}
