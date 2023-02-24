//
//  LaunchModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 24.02.2023.
//

import UIKit
import Combine

enum LaunchTransition: Transition {
    case signIn
    case testModule
}

final class LaunchModuleBuilder {
    class func build(container: AppContainer) -> Module<LaunchTransition, UIViewController> {
        let viewModel = LaunchViewModel()
        let viewController = LaunchViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
