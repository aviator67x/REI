//
//  SearchViewController.swift
//  RomaMVVM
//
//  Created by User on 24.03.2023.
//

import UIKit
import Combine

final class SearchViewController: BaseViewController<SearchViewModel> {
    // MARK: - Views
    private let contentView = SearchView()
    private let segmentControl = UISegmentedControl()

    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupNavigation()
        setupBindings()
    }

    private func setupNavigation() {
        segmentControl.setTitle("Photo", forSegmentAt: 0)
        segmentControl.setTitle("List", forSegmentAt: 1)
        segmentControl.setTitle("Map", forSegmentAt: 2)
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
        
        segmentControl.selectedSegmentIndexPublisher
            .sinkWeakly(self, receiveValue: {(self, index) in
                self.viewModel.configureScreen(for: index)
            })
            .store(in: &cancellables)
        
        viewModel.$sections
            .sinkWeakly(self, receiveValue: { (self, sections) in
                self.contentView.setupSnapshot(sections: sections)
            })
            .store(in: &cancellables)
    }
}
