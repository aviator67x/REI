//
//  FavouriteModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 27.04.2023.
//

import UIKit
import Combine

enum FavouriteTransition: Transition {
    
}

final class FavouriteModuleBuilder {
    class func build(container: AppContainer) -> Module<FavouriteTransition, UIViewController> {
        let viewModel = FavouriteViewModel()
        let viewController = FavouriteViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
