//
//  ConstructionYearViewController.swift
//  RomaMVVM
//
//  Created by User on 03.04.2023.
//

import UIKit

final class ConstructionYearViewController: BaseViewController<ConstructionYearViewModel> {
    // MARK: - Views
    private let contentView = ConstructionYearView()
    
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
                case .selectedItem(let item):
                    switch item {
                    case .plain(let text):
                        viewModel.updateRequestModel(text)
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.$sections
            .sinkWeakly(self, receiveValue: { (self, sections) in
                self.contentView.setupSnapShot(sections: sections)
            })
            .store(in: &cancellables)
    }
}
