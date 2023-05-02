//
//  SearchModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 24.03.2023.
//

import UIKit
import Combine

enum SearchFiltersTransition: Transition {
    case detailed(SearchModel, SearchFiltersDetailedScreenState)
    case pop
}

final class SearchFiltersModuleBuilder {
    class func build(container: AppContainer, model: SearchModel) -> Module<SearchFiltersTransition, UIViewController> {
        let viewModel = SearchFiltersViewModel(model: model)
        let viewController = SearchFiltersViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
