//
//  EmailViewController.swift
//  RomaMVVM
//
//  Created by User on 20.03.2023.
//

import UIKit

final class EmailViewController: BaseViewController<EmailViewModel> {
    // MARK: - Views
    private let contentView = EmailView()
    
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
