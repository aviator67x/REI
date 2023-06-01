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
        navigationItem
            .leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: UIImage(systemName: "chevron.left")))
        setupBindings()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .navBarAlfaOnScroll(let alfa):
                    self.navigationController?.navigationBar.alpha = alfa
                case .onHeartButtonTap:
                    break
//                    viewModel.editFavorites()
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
