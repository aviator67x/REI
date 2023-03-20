//
//  PasswordViewController.swift
//  RomaMVVM
//
//  Created by User on 20.03.2023.
//

import UIKit

final class PasswordViewController: BaseViewController<PasswordViewModel> {
    // MARK: - Views
    private let contentView = PasswordView()
    
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
                }
            }
            .store(in: &cancellables)
    }
}
