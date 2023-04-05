//
//  FindModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import UIKit
import Combine

enum FindTransition: Transition {
    
}

final class FindModuleBuilder {
    class func build(container: AppContainer) -> Module<FindTransition, UIViewController> {
        let viewModel = FindViewModel()
        let viewController = FindViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
