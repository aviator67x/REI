//
//  FindViewController.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import Combine
import UIKit

final class FindViewController: BaseViewController<FindViewModel> {
    // MARK: - Views
    private let contentView = FindView()
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
                }
            }
            .store(in: &cancellables)

        viewModel.$sections
            .sinkWeakly(self, receiveValue: { (self, sections) in
                self.contentView.setupSnapShot(sections: sections)
                var resultCount = 0
                if let section = sections.first(where: {$0.section == .photo}) {
                    resultCount =  section.items.count
                } else if let section = sections.first(where: {$0.section == .list}) {
                    resultCount = section.items.count
                }
                let resultModel = SearchResultViewModel(country: "Netherlands", result: resultCount, filters: 9)
                self.contentView.updateSearchResultView(with: resultModel)
            })
            .store(in: &cancellables)

        segmentedControl.selectedSegmentIndexPublisher
            .compactMap { FindScreenState(rawValue: $0) }
            .sink { [unowned self] state in
                viewModel.setScreenState(state)
                contentView.makeSelectView(isVisible: state != .map)
            }
            .store(in: &cancellables)           
    }
}
