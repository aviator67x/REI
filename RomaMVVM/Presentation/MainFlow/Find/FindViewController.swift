//
//  FindViewController.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import UIKit

final class FindViewController: BaseViewController<FindViewModel> {
    
    // MARK: - Views
    private let contentView = FindView()
    
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
                case .collectionBottomDidReach:
                    viewModel.loadHouses()
                case .collectionTopScrollDidBegin(let offset):
                    viewModel.setSelect(for: offset)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$sections
            .sinkWeakly(self, receiveValue: { (self, sections) in
                self.contentView.setupSnapShot(sections: sections)
            })
            .store(in: &cancellables)
        
        viewModel.$isSelectHidden
            .sinkWeakly(self, receiveValue: { (self, value) in
                self.contentView.setupLayout(hideSelect: value)
            })
            .store(in: &cancellables)
    }
}
