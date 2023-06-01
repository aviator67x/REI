//
//  SelectedHouseModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 31.05.2023.
//

import UIKit
import Combine

enum SelectedHouseTransition: Transition {
    
}

final class SelectedHouseModuleBuilder {
    class func build(container: AppContainer, house: HouseDomainModel) -> Module<SelectedHouseTransition, UIViewController> {
        let viewModel = SelectedHouseViewModel(house: house)
        let viewController = SelectedHouseViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
