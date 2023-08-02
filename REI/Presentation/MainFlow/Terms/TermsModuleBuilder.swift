//
//  TermsModuleBuilder.swift
//  REI
//
//  Created by User on 20.03.2023.
//

import UIKit
import Combine

enum TermsTransition: Transition {
    
}

final class TermsModuleBuilder {
    class func build(container: AppContainer) -> Module<TermsTransition, UIViewController> {
        let viewModel = TermsViewModel()
        let viewController = TermsViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
