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
                }
            }
            .store(in: &cancellables)
    }
}
