//
//  FavouriteViewController.swift
//  REI
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
                case let .selectedItem(item):
                    viewModel.showSelectedItem(item)
                case let .remove(item):
                    viewModel.deleteItem(item)
                }
            }
            .store(in: &cancellables)

        viewModel.sectionsPublisher
            .sinkWeakly(self, receiveValue: { (self, sections) in
                self.contentView.setupSnapShot(sections: sections)
            })
            .store(in: &cancellables)

        viewModel.favouriteHousesPublisher
            .sinkWeakly(self, receiveValue: { (self, favouriteHouses) in
                self.contentView.updateInfoView(with: favouriteHouses.count)
            })
            .store(in: &cancellables)
    }
}
