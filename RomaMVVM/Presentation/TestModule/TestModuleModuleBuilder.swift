//
//  TestModuleModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 16.01.2023.
//

import UIKit
import Combine

enum TestModuleTransition: Transition {
    case signUp, forgotPassword
}

final class TestModuleModuleBuilder {
    class func build(container: AppContainer) -> Module<TestModuleTransition, UIViewController> {
        let viewModel = TestModuleViewModel(authService: container.authService, instaService: container.instaService)
        let viewController = TestModuleViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
