//
//  FindModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import UIKit
import Combine

enum FindTransition: Transition {
    case search
    case sort
    case favourite
}

final class SearchResultsModuleBuilder {
    class func build(container: AppContainer) -> Module<FindTransition, UIViewController> {
        let model = SearchResultsModel(housesService: container.housesService)
        let viewModel = SearchResultsViewModel(model: model)
        let viewController = SearchResultsViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
