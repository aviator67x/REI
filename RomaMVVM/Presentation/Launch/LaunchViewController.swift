//
//  LaunchViewController.swift
//  RomaMVVM
//
//  Created by User on 24.02.2023.
//

import UIKit

final class LaunchViewController: BaseViewController<LaunchViewModel> {
    // MARK: - Views
    private let contentView = LaunchView()
    
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
