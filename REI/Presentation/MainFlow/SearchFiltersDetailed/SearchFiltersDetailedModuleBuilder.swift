//
//  ConstructionYearModuleBuilder.swift
//  REI
//
//  Created by User on 03.04.2023.
//

import UIKit
import Combine

enum SearchFiltersDetailedTransition: Transition {    
}

final class SearchFiltersDetailedModuleBuilder {
    class func build(container: AppContainer, model: SearchModel, screenState: SearchFiltersDetailedScreenState) -> Module<SearchFiltersDetailedTransition, UIViewController> {
        let viewModel = SearchFiltersDetailedViewModel(model: model, screenState: screenState)
        let viewController = SearchFiltersDetailedViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
