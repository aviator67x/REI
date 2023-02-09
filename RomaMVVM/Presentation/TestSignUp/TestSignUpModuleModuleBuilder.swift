//
//  TestSignUpModuleModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 03.02.2023.
//

import UIKit
import Combine

enum TestSignUpModuleTransition: Transition {
    case success
}

final class TestSignUpModuleModuleBuilder {
    class func build(container: AppContainer) -> Module<TestSignUpModuleTransition, UIViewController> {
        let viewModel = TestSignUpModuleViewModel()
        let viewController = TestSignUpModuleViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
