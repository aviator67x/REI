//
//  AdDetailsModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 22.05.2023.
//

import UIKit
import Combine

enum AdDetailsTransition: Transition {
    case type(model: AdCreatingModel, screenState: AdMultiDetailsScreenState)
    case number(model: AdCreatingModel, screenState: AdMultiDetailsScreenState)
    case year(model: AdCreatingModel, screenState: AdMultiDetailsScreenState)
    case garage(model: AdCreatingModel, screenState: AdMultiDetailsScreenState)
    case livingArea(model: AdCreatingModel, screenState: AdMultiDetailsScreenState)
    case square(model: AdCreatingModel, screenState: AdMultiDetailsScreenState)
    case price(model: AdCreatingModel, screenState: AdMultiDetailsScreenState)
    case showAdPhoto(moodel: AdCreatingModel)
    case myHouse
    case popScreen
}

final class AdDetailsModuleBuilder {
    class func build(container: AppContainer, model: AdCreatingModel) -> Module<AdDetailsTransition, UIViewController> {
        let viewModel = AdDetailsViewModel(model: model)
        let viewController = AdDetailsViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
