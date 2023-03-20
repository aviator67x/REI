//
//  NameModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 20.03.2023.
//

import UIKit
import Combine

enum NameTransition: Transition {
    
}

final class NameModuleBuilder {
    class func build(container: AppContainer) -> Module<NameTransition, UIViewController> {
        let viewModel = NameViewModel()
        let viewController = NameViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
