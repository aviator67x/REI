//
//  MyHouseModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 27.04.2023.
//

import UIKit
import Combine

enum MyHouseTransition: Transition {
    case moveToAdAddress
}

final class MyHouseModuleBuilder {
    class func build(container: AppContainer) -> Module<MyHouseTransition, UIViewController> {
        let viewModel = MyHouseViewModel(userService: container.userService, housesService: container.housesService)
        let viewController = MyHouseViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
