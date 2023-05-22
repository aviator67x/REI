//
//  AdCreatingModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 15.05.2023.
//

import UIKit
import Combine

enum AdCreatingTransition: Transition {
    
}

final class AdCreatingModuleBuilder {
    class func build(container: AppContainer) -> Module<AdCreatingTransition, UIViewController> {

        let viewModel = AdCreatingViewModel(model: container.adCreatingModel)
        let viewController = AdCreatingViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
