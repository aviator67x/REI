//
//  SignInModuleBuilder.swift
//  REI
//
//  Created by user on 12.02.2023.
//

import UIKit
import Combine

enum SignInTransition: Transition {
    case success
    case forgotPassword
    case signUp
}

final class SignInModuleBuilder {
    class func build(container: AppContainer) -> Module<SignInTransition, UIViewController> {
        let viewModel = SignInViewModel(authService: container.authNetworkService,
                                        userService: container.userService)
        let viewController = SignInViewController(viewModel: viewModel)
        return Module(viewController: viewController,
                      transitionPublisher: viewModel.transitionPublisher)
    }
}
