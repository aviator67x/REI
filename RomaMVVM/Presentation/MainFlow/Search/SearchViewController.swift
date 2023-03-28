//
//  SearchViewController.swift
//  RomaMVVM
//
//  Created by User on 24.03.2023.
//

import Combine
import UIKit

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
        setupNavigation()
        setupBindings()
    }

    private func setupNavigation() {
        title = "Search"

        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetDidTap))
        navigationItem.leftBarButtonItem = resetButton

        let bell = UIButton()
        bell.setImage(UIImage(systemName: "bell"), for: .normal)
        bell.addTarget(self, action: #selector(bellDidTap), for: .touchUpInside)
        bell.frame = CGRectMake(0, 0, 20, 20)
        let bellButton = UIBarButtonItem(customView: bell)
        
        let cross = UIButton()
        cross.setImage(UIImage(systemName: "multiply"), for: .normal)
        cross.addTarget(self, action: #selector(bellDidTap), for: .touchUpInside)
        cross.frame = CGRectMake(0, 0, 20, 20)
        let crossButton = UIBarButtonItem(customView: cross)
        
        navigationItem.rightBarButtonItems = [crossButton, bellButton]
//        segmentControl.setTitle("Photo", forSegmentAt: 0)
//        segmentControl.setTitle("List", forSegmentAt: 1)
//        segmentControl.setTitle("Map", forSegmentAt: 2)
//        segmentControl.sizeToFit()
//        segmentControl.selectedSegmentIndex = 0
//        segmentControl.setTitleTextAttributes(
//            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)],
//            for: .normal
//        )
//        segmentControl.backgroundColor = .systemBackground
//        navigationItem.titleView = segmentControl
    }

    @objc
    private func resetDidTap() {}

    @objc
    private func bellDidTap() {}

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in

                switch action {}
            }
            .store(in: &cancellables)

        segmentControl.selectedSegmentIndexPublisher
            .sinkWeakly(self, receiveValue: { (self, index) in
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
