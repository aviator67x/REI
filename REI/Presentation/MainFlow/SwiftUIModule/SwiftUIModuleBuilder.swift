//
//  SwiftUIModuleBuilder.swift
//  REI
//
//  Created by User on 14.08.2023.
//

import UIKit
import Combine

enum SwiftUITransition: Transition {
    
}

final class SwiftUIModuleBuilder {
    class func build(container: AppContainer) -> Module<SwiftUITransition, UIViewController> {
        let viewModel = SwiftUIViewModel()
        let viewController = SwiftUIViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
