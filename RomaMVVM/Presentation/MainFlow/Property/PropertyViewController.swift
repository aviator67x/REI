//
//  PropertyViewController.swift
//  RomaMVVM
//
//  Created by User on 06.03.2023.
//

import UIKit

final class PropertyViewController: BaseViewController<PropertyViewModel> {
    // MARK: - Views
    private let contentView = PropertyView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setImage()
        super.viewWillAppear(animated)
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .filterDidTap:
                    viewModel.filter()
                }
            }
            .store(in: &cancellables)
        
        viewModel.propertyIdPublisher
            .sink { [unowned self] id in
                contentView.setLabel(id: id)
            }
            .store(in: &cancellables)
    }
    
    func setImage() {
        contentView.setImage()
    }
    
}
