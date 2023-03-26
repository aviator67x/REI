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
        setupNavigation()
        setupBindings()
    }

    private func setupNavigation() {       
        let segmentControl = UISegmentedControl(items: ["Photo", "List", "Map"])
        segmentControl.sizeToFit()
        segmentControl.selectedSegmentIndex = 0
        segmentControl.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)],
            for: .normal
        )
        segmentControl.backgroundColor = .systemBackground
        navigationItem.titleView = segmentControl
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {}
            }
            .store(in: &cancellables)
    }
}
