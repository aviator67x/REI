//
//  HouseImagesViewController.swift
//  RomaMVVM
//
//  Created by User on 06.06.2023.
//

import UIKit

final class HouseImagesViewController: BaseViewController<HouseImagesViewModel> {
    // MARK: - Views
    private let contentView = HouseImagesView()
    
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
