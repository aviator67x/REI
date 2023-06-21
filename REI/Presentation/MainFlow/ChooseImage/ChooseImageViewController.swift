//
//  ChooseImageViewController.swift
//  RomaMVVM
//
//  Created by User on 21.03.2023.
//

import UIKit

final class ChooseImageViewController: BaseViewController<ChooseImageViewModel> {
    // MARK: - Views
    private let contentView = ChooseImageView()
    
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
