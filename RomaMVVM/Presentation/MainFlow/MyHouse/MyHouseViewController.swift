//
//  MyHouseViewController.swift
//  RomaMVVM
//
//  Created by User on 27.04.2023.
//

import UIKit

final class MyHouseViewController: BaseViewController<MyHouseViewModel> {
    // MARK: - Views
    private let contentView = MyHouseView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MyHouse"
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .buttonDidTap:
                    viewModel.moveToNextAd()
                }
            }
            .store(in: &cancellables)
    }
}
