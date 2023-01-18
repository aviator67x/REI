//
//  TestModuleModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 16.01.2023.
//

import UIKit
import Combine

enum TestModuleTransition: Transition {
    
}

final class TestModuleModuleBuilder {
    class func build(container: AppContainer) -> Module<TestModuleTransition, UIViewController> {
        let viewModel = TestModuleViewModel(dogServce: container.dogService)
        let viewController = TestModuleViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
