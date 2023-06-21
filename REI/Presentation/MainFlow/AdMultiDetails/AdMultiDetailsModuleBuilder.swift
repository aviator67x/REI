//
//  AdMultiDetailsModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 22.05.2023.
//

import UIKit
import Combine

enum AdMultiDetailsTransition: Transition {
    case myHouse
    case popScreen
}

final class AdMultiDetailsModuleBuilder {
    class func build(container: AppContainer, model: AdCreatingModel, screenState: AdMultiDetailsScreenState) -> Module<AdMultiDetailsTransition, UIViewController> {
        let viewModel = AdMultiDetailsViewModel(model: model, screenState: screenState)
        let viewController = AdMultiDetailsViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
