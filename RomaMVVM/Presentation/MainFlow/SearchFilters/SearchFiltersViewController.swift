//
//  SearchViewController.swift
//  RomaMVVM
//
//  Created by User on 24.03.2023.
//

import Combine
import UIKit

final class SearchFiltersViewController: BaseViewController<SearchFiltersViewModel> {
    // MARK: - Views
    private let contentView = SearchFiltersView()

    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupBindings()
    }

    private func setupNavigation() {
        title = "Search"

        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetDidTap))
        navigationItem.leftBarButtonItem = resetButton

        let bell = UIButton()
        bell.setImage(UIImage(systemName: "bell"), for: .normal)
        bell.addTarget(self, action: #selector(bellDidTap), for: .touchUpInside)
        bell.frame = CGRectMake(0, 0, 20, 20)
        let bellButton = UIBarButtonItem(customView: bell)
        
        let cross = UIButton()
        cross.setImage(UIImage(systemName: "multiply"), for: .normal)
        cross.addTarget(self, action: #selector(crossDidTap), for: .touchUpInside)
        cross.frame = CGRectMake(0, 0, 20, 20)
        let crossButton = UIBarButtonItem(customView: cross)
        
        navigationItem.rightBarButtonItems = [crossButton, bellButton]
    }

    @objc
    private func resetDidTap() {
        viewModel.cleanFilters()
    }

    @objc
    private func bellDidTap() {}
    
    @objc
    private func crossDidTap() {
        viewModel.popModule()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .selectedItem(let item):
                    switch item {                        
                    case .segmentControl:
                       break
                    case .distance(let distance):
                        let param =  distance
                       viewModel.updateDistance(param)
                    case .price:
                        break
                    case .type(let type):
                        viewModel.updateType(type)
                    case .square:
                        break
                    case .roomsNumber(let number):
                        viewModel.updateNumberOfRooms(number)
                    case .year:
                        viewModel.showDetailed(state: .year)
                    case .garage:
                        viewModel.showDetailed(state: .garage)
                    case .backgroundItem:
                        break
                    }
                case .segmentControl(let index):
                    viewModel.configureScreen(for: index)
                case .resultButtonDidTap:
                    viewModel.executeSearch()
                }
            }
            .store(in: &cancellables)

        viewModel.$sections
            .sinkWeakly(self, receiveValue: { (self, sections) in
                self.contentView.setupSnapshot(sections: sections)
            })
            .store(in: &cancellables)
    }
}
