//
//  PasswordModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 20.03.2023.
//

import UIKit
import Combine

enum PasswordTransition: Transition {
    
}

final class PasswordModuleBuilder {
    class func build(container: AppContainer) -> Module<PasswordTransition, UIViewController> {
        let viewModel = PasswordViewModel()
        let viewController = PasswordViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
