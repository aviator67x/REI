//
//  FindViewController.swift
//  REI
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
        contentView.setupBanner(self)
    }

    // MARK: - Private methods
    private func setupNavigationBar() {
        navigationItem.titleView = segmentedControl
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(showSwiftUIModule))
        let imageView = UIImageView(image: UIImage(systemName: "face.dashed"))
        imageView.addGestureRecognizer(recognizer)
        navigationItem
            .leftBarButtonItem = UIBarButtonItem(customView: imageView)
    }

    @objc
    private func showSwiftUIModule() {
        let vc = SwiftUIModuleBuilder.build().viewController
        present(vc, animated: true)
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .collectionBottomDidReach:
                    viewModel.loadHouses()
                case let .fromSelectViewTransition(screen):
                    viewModel.moveTo(screen)
                case let .onCellHeartButtonPublisher(selectedItem: selectedItem):
                    viewModel.editFavourites(item: selectedItem)
                case let .selectedItem(item):
                    viewModel.showSelectedItem(item)
                case let .showAlert(alert):
                    self.present(alert, animated: true)
                case let .visiblePoligon(poligon):
                    viewModel.getAvailableHouses(in: poligon)
                case .refreshCollection:
                    viewModel.refreshFeed()
                }
            }
            .store(in: &cancellables)

        viewModel.sectionsPublisher
            .dropFirst()
            .sinkWeakly(self, receiveValue: { (self, sections) in
                self.contentView.showCollection(sections: sections)
            })
            .store(in: &cancellables)

        viewModel.mapViewPublisher
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, model) in
                self.contentView.showMapView(model: model)
            })
            .store(in: &cancellables)

        viewModel.availableInPoligonHouesesPublisher
            .sinkWeakly(self) { (self, availableHouses) in
                availableHouses.forEach { house in
                    guard let location = house.location else {
                        return
                    }
                    let address = ""
                    self.contentView.showOnMap(location: location, address: address)
                }
            }
            .store(in: &cancellables)

        viewModel.resultViewModelPublisher
            .sinkWeakly(self, receiveValue: { (self, resultModel) in
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
