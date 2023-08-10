//
//  SortModuleBuilder.swift
//  REI
//
//  Created by User on 03.08.2023.
//

import UIKit
import Combine

enum SortTransition: Transition {
    case popScreen
}

final class SortModuleBuilder {
    class func build(container: AppContainer) -> Module<SortTransition, UIViewController> {
        let viewModel = SortViewModel(searchModel: container.searchModel)
        let viewController = SortViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
