//
//  ConstructionYearModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 03.04.2023.
//

import UIKit
import Combine

enum ConstructionYearTransition: Transition {
    
}

final class ConstructionYearModuleBuilder {
    class func build(container: AppContainer, searchRequestModel: SearchRequestModel, screenState: ScreenState) -> Module<ConstructionYearTransition, UIViewController> {
        let viewModel = ConstructionYearViewModel(requestModel: searchRequestModel, screenState: screenState)
        let viewController = ConstructionYearViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
