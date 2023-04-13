//
//  FindModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import UIKit
import Combine

enum FindTransition: Transition {
    case home
}

final class FindModuleBuilder {
    class func build(container: AppContainer) -> Module<FindTransition, UIViewController> {
        let viewModel = FindViewModel(houseNetworkService: container.houseMetworkService)
        let viewController = FindViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
