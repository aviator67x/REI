//
//  AdAdressModuleBuilder.swift
//  REI
//
//  Created by User on 19.05.2023.
//

import UIKit
import Combine

enum AdAddressTransition: Transition {
    case myHouse
    case adDetails(model: AdCreatingModel)
}

final class AdAddressModuleBuilder {
    class func build(container: AppContainer, model: AdCreatingModel) -> Module<AdAddressTransition, UIViewController> {
        let viewModel = AdAddressViewModel(model: model)
        let viewController = AdAddressViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}