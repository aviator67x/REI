//
//  TermsViewController.swift
//  REI
//
//  Created by User on 20.03.2023.
//

import UIKit

final class TermsViewController: BaseViewController<TermsViewModel> {
    // MARK: - Views
    private let contentView = TermsView()
    
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
            .sink { action in
              
            }
            .store(in: &cancellables)
    }
}
