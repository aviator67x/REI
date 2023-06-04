//
//  SelectedHouseViewController.swift
//  RomaMVVM
//
//  Created by User on 31.05.2023.
//

import UIKit

final class SelectedHouseViewController: BaseViewController<SelectedHouseViewModel> {
    // MARK: - Views
    private let contentView = SelectedHouseView()

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
                case let .navBarAlfaOnScroll(isHidden):
                    self.navigationController?.navigationBar.isHidden = isHidden ? false : false
                case let .onHeartButtonTap(id):
                    viewModel.editFavorites(with: id)
                }
            }
            .store(in: &cancellables)

        viewModel.housePublisher
            .sinkWeakly(self, receiveValue: { (self, house) in
                guard let house = house else {
                    return
                }
                self.contentView.setupView(house)
            })
            .store(in: &cancellables)
    }
}
