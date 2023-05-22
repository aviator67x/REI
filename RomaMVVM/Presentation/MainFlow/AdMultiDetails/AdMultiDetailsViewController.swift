//
//  AdMultiDetailsViewController.swift
//  RomaMVVM
//
//  Created by User on 22.05.2023.
//

import UIKit

final class AdMultiDetailsViewController: BaseViewController<AdMultiDetailsViewModel> {
    // MARK: - Views
    private let contentView = AdMultiDetailsView()
    
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
