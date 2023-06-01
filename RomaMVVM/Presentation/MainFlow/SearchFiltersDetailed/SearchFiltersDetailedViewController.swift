//
//  ConstructionYearViewController.swift
//  RomaMVVM
//
//  Created by User on 03.04.2023.
//

import UIKit

final class SearchFiltersDetailedViewController: BaseViewController<SearchFiltersDetailedViewModel> {
    // MARK: - Views
    private let contentView = SearchFiltersDetailedView()
    
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
                    case .plainYear(let year):
                        viewModel.updateRequestModel(year: year)
                    case .plainGarage(let garage):
                        viewModel.updateRequestModel(garage: garage)
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.$sections
            .sinkWeakly(self, receiveValue: { (self, sections) in
                self.contentView.setupSnapShot(sections: sections)
            })
            .store(in: &cancellables)
        
        viewModel.popDetailedPublisher
            .sinkWeakly(self, receiveValue: { (_, value) in
                if value {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            .store(in: &cancellables)
    }
}
