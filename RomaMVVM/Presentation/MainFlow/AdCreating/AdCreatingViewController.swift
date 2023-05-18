//
//  AdCreatingViewController.swift
//  RomaMVVM
//
//  Created by User on 15.05.2023.
//

import UIKit

final class AdCreatingViewController: BaseViewController<AdCreatingViewModel> {
    // MARK: - Views
    private let contentView = AdCreatingView()
    
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
                    break
                case .ort(let ort):
                    viewModel.updateOrt(ort: ort)
                case .street(let street):
                    viewModel.updateStreet(street: street)
                case .house(let house):
                    viewModel.updateHouse(house: house)
                }
            }
            .store(in: &cancellables)
        
        viewModel.validationPublisher
            .receive(on: DispatchQueue.main)
            .sinkWeakly(self, receiveValue: { (self, model) in
                self.contentView.showValidationLabel(model)
            })
            .store(in: &cancellables)
    }
}
