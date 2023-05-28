//
//  AdPhotosModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 25.05.2023.
//

import UIKit
import Combine

enum AdPhotosTransition: Transition {
    case pop
}

final class AdPhotosModuleBuilder {
    class func build(container: AppContainer, model: AdCreatingModel) -> Module<AdPhotosTransition, UIViewController> {
        let viewModel = AdPhotosViewModel(model: model)
        let viewController = AdPhotosViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}