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

final class FindModuleBuilder {
    class func build(container: AppContainer) -> Module<FindTransition, UIViewController> {
        let model = FindModel(housesService: container.housesService)
        let viewModel = FindViewModel(model: model)
        let viewController = FindViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
