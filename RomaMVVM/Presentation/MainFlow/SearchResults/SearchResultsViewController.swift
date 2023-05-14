//
//  FindViewController.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import Combine
import UIKit

final class SearchResultsViewController: BaseViewController<SearchResultsViewModel> {
    // MARK: - Views
    private let contentView = SearchResultsView()
    private lazy var segmentedControl = SegmentedControl(frame: .zero)

    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationItem.titleView = segmentedControl
        navigationItem
            .leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: UIImage(systemName: "face.dashed")))
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .collectionBottomDidReach:
                    viewModel.loadHouses()
                case .fromSelectViewTransition(let screen):
                    viewModel.moveTo(screen)
                case .onCellHeartButtonPublisher(selectedItem: let selectedItem):
                    viewModel.editToFavourites(item: selectedItem)
                }
            }
            .store(in: &cancellables)

        viewModel.sectionsPublisher
            .sinkWeakly(self, receiveValue: { (self, sections) in
                self.contentView.setupSnapShot(sections: sections)
            })
            .store(in: &cancellables)
        
        viewModel.resultViewModelPublisher
            .sinkWeakly(self, receiveValue: {(self, resultModel) in
                guard let resultModel = resultModel else {
                    return
                }
                self.contentView.updateResultView(with: resultModel)
            })
            .store(in: &cancellables)

        segmentedControl.selectedSegmentIndexPublisher
            .compactMap { SearchResultsScreenState(rawValue: $0) }
            .sink { [unowned self] state in
                viewModel.setScreenState(state)
                contentView.makeSelectView(isVisible: state != .map)
            }
            .store(in: &cancellables)           
    }
}
