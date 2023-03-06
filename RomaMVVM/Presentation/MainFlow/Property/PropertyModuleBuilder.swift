//
//  PropertyModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 06.03.2023.
//

import UIKit
import Combine

enum PropertyTransition: Transition {
    case home
}

final class PropertyModuleBuilder {
    class func build(container: AppContainer) -> Module<PropertyTransition, UIViewController> {
        let viewModel = PropertyViewModel()
        let viewController = PropertyViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
