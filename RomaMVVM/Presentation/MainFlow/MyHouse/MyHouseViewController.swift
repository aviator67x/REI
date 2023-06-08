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
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .buttonDidTap:
                    viewModel.moveToNextAd()
                case .selectedItem(let item):
                    viewModel.delete(item)
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
