//
//  SignUpModuleBuilder.swift
//  REI
//
//  Created by user on 12.02.2023.
//

import UIKit
import Combine

enum SignUpTransition: Transition {
    case success
    case popScreen
}

final class SignUpModuleBuilder {
    class func build(container: AppContainer) -> Module<SignUpTransition, UIViewController> {
        let viewModel = SignUpViewModel(authService: container.authNetworkService, userService: container.userService)
        let viewController = SignUpViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
