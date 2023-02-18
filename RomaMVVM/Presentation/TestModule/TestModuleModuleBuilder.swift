//
//  TestModuleModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 16.01.2023.
//

import UIKit
import Combine

enum TestModuleTransition: Transition {
    case signUp, testSignUp, forgotPassword
}

final class TestModuleModuleBuilder {
    class func build(container: AppContainer) -> Module<TestModuleTransition, UIViewController> {
        let viewModel = TestModuleViewModel(authService: container.authService,
                                            userService: container.userService)
        let viewController = TestModuleViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
