//
//  AdAdressViewController.swift
//  RomaMVVM
//
//  Created by User on 19.05.2023.
//

import UIKit

final class AdAddressViewController: BaseViewController<AdAddressViewModel> {
    // MARK: - Views
    private let contentView = AdAddressView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupBindings()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .crossDidTap:
                    viewModel.moveToMyHouse()
                case .forwardDidTap:
                    break
                case .ort(let text):
                    viewModel.validateOrt(text)
                case .street(let text):
                    viewModel.validateStreet(text)
                case .house(let text):
                    viewModel.validateHouse(text)
                }
            }
            .store(in: &cancellables)
        
        viewModel.validationPublisher
            .sinkWeakly(self, receiveValue: { (self, model) in
                self.contentView.setupView(with: model)
            })
            .store(in: &cancellables)
    }
}
