//
//  MyHouseModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 27.04.2023.
//

import UIKit
import Combine

enum MyHouseTransition: Transition {
    
}

final class MyHouseModuleBuilder {
    class func build(container: AppContainer) -> Module<MyHouseTransition, UIViewController> {
        let viewModel = MyHouseViewModel()
        let viewController = MyHouseViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}