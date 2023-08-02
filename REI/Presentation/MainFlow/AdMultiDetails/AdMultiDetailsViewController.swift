//
//  AdMultiDetailsViewController.swift
//  REI
//
//  Created by User on 22.05.2023.
//

import UIKit

final class AdMultiDetailsViewController: BaseViewController<AdMultiDetailsViewModel> {
    // MARK: - Views
    private let contentView = AdMultiDetailsView()

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
                case let .selectedItem(item):
                    viewModel.updateAdCreatingModel(for: item)
                case .onCrossTap:
                    viewModel.popScreen()
                case let .year(year):
                    viewModel.updateAdCreatingModel(for: .yearPicker(year))
                case let .livingArea(livingArea):
                    viewModel.updateAdCreatingModel(for: .livingAreaSlider(livingArea))
                case let .square(square):
                    viewModel.updateAdCreatingModel(for: .squareSlider(square))
                case let .price(price):
                    viewModel.updateAdCreatingModel(for: .priceSlider(price))
                }
            }
            .store(in: &cancellables)

        viewModel.sectionsPublisher
            .sinkWeakly(self, receiveValue: { (self, sections) in
                self.contentView.setupSnapShot(sections: sections)
            })
            .store(in: &cancellables)
    }
}
