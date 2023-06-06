//
//  HouseImagesModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 06.06.2023.
//

import UIKit
import Combine

enum HouseImagesTransition: Transition {
    
}

final class HouseImagesModuleBuilder {
    class func build(container: AppContainer) -> Module<HouseImagesTransition, UIViewController> {
        let viewModel = HouseImagesViewModel()
        let viewController = HouseImagesViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
