//
//  PropertyViewController.swift
//  RomaMVVM
//
//  Created by User on 06.03.2023.
//

import UIKit

final class PropertyViewController: BaseViewController<PropertyViewModel> {
    // MARK: - Views
    private let contentView = PropertyView()
    
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
