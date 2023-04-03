//
//  SettingsViewController.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import UIKit

final class SettingsViewController: BaseViewController<SettingsViewModel> {
    // MARK: - Views
    private let contentView = SettingsView()

    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        title = Localization.settings
    }

    private func setupBindings() {
        viewModel.$sections
            .sink { [unowned self] value in
            contentView.setupSnapShot(sections: value)
        }
        .store(in: &cancellables)
        
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .selectedItem(let item):
                    switch item {
                    case .userProfile:
                        break
                    case .plain(title: let title):
                        switch title {
                        case "Profile": viewModel.showProfile()
                        case "Terms and Conditions": viewModel.showTerms()
                        default:
                            break
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}
