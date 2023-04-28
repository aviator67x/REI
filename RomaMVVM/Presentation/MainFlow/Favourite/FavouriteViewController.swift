//
//  FavouriteViewController.swift
//  RomaMVVM
//
//  Created by User on 27.04.2023.
//

import UIKit

final class FavouriteViewController: BaseViewController<FavouriteViewModel> {
    // MARK: - Views
    private let contentView = FavouriteView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourite"
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
