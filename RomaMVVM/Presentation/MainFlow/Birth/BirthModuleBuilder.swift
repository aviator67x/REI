//
//  BirthModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 20.03.2023.
//

import UIKit
import Combine

enum BirthTransition: Transition {
    
}

final class BirthModuleBuilder {
    class func build(container: AppContainer) -> Module<BirthTransition, UIViewController> {
        let viewModel = BirthViewModel()
        let viewController = BirthViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
