//
//  FavouriteModuleBuilder.swift
//  REI
//
//  Created by User on 27.04.2023.
//

import UIKit
import Combine

enum FavouriteTransition: Transition {
    case selectedHouse(HouseDomainModel)
}

final class FavouriteModuleBuilder {
    class func build(container: AppContainer) -> Module<FavouriteTransition, UIViewController> {
        let viewModel = FavouriteViewModel(model: container.searchModel)
        let viewController = FavouriteViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
