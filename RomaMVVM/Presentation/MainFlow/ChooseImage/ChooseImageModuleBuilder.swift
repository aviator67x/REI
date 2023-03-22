//
//  ChooseImageModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 21.03.2023.
//

import UIKit
import Combine

enum ChooseImageTransition: Transition {
    
}

final class ChooseImageModuleBuilder {
    class func build(container: AppContainer) -> Module<ChooseImageTransition, UIViewController> {
        let viewModel = ChooseImageViewModel()
        let viewController = ChooseImageViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
