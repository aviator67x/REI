//
//  FindModuleBuilder.swift
//  REI
//
//  Created by User on 05.04.2023.
//

import UIKit
import Combine

enum FindTransition: Transition {
    case searchFilters(SearchModel)
    case sort
    case favourite
    case selectedHouse(HouseDomainModel)
}

final class SearchResultsModuleBuilder {
    class func build(container: AppContainer) -> Module<FindTransition, UIViewController> {
        let viewModel = SearchResultsViewModel(model: container.searchModel)
        let viewController = SearchResultsViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
