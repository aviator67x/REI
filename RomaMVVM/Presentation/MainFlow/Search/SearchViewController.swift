//
//  SearchViewController.swift
//  RomaMVVM
//
//  Created by User on 24.03.2023.
//

import UIKit

final class SearchViewController: BaseViewController<SearchViewModel> {
    // MARK: - Views
    private let contentView = SearchView()
    
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
