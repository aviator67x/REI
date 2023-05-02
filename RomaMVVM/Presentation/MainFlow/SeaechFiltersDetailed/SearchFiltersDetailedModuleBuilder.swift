//
//  ConstructionYearModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 03.04.2023.
//

import UIKit
import Combine

enum SearchFiltersDetailedTransition: Transition {    
}

final class SearchFiltersDetailedModuleBuilder {
    class func build(container: AppContainer, searchRequestModel: SearchRequestModel, screenState: SearchFiltersDetailedScreenState) -> Module<SearchFiltersDetailedTransition, UIViewController> {
        let viewModel = SearchFiltersDetailedViewModel(requestModel: searchRequestModel, screenState: screenState)
        let viewController = SearchFiltersDetailedViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
