//
//  EmailModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 20.03.2023.
//

import UIKit
import Combine

enum EmailTransition: Transition {
    
}

final class EmailModuleBuilder {
    class func build(container: AppContainer) -> Module<EmailTransition, UIViewController> {
        let viewModel = EmailViewModel()
        let viewController = EmailViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
