//
//  PasswordRestoreModuleBuilder.swift
//  REI
//
//  Created by User on 27.02.2023.
//

import UIKit
import Combine

enum PasswordRestoreTransition: Transition {
    case success
    case popScreen
    case finishFow
}

final class PasswordRestoreModuleBuilder {
    class func build(container: AppContainer) -> Module<PasswordRestoreTransition, UIViewController> {
        let viewModel = PasswordRestoreViewModel(authServicw: container.authNetworkService)
        let viewController = PasswordRestoreViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}