//
//  AdCreatingViewController.swift
//  RomaMVVM
//
//  Created by User on 15.05.2023.
//

import UIKit

final class AdCreatingViewController: BaseViewController<AdCreatingViewModel> {
    // MARK: - Views
    private let contentView = AdCreatingView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupBindings()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .crossDidTap:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
