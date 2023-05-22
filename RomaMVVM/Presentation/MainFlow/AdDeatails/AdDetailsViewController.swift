//
//  AdDetailsViewController.swift
//  RomaMVVM
//
//  Created by User on 22.05.2023.
//

import UIKit

final class AdDetailsViewController: BaseViewController<AdDetailsViewModel> {
    // MARK: - Views
    private let contentView = AdDetailsView()
    
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
                case .onBackTap:
                    viewModel.moveBack()
                case .onTypeTap:
                    viewModel.moveToType()
                case .onNumberTap:
                    viewModel.moveToNumber()
                case .onYearTap:
                    viewModel.moveToYear()
                case .onGarageTap:
                    viewModel.moveToGarage()
                }
            }
            .store(in: &cancellables)
    }
}
