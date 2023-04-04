//
//  ConstructionYearModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 03.04.2023.
//

import UIKit
import Combine

enum DetailedTransition: Transition {    
}

final class DetailedModuleBuilder {
    class func build(container: AppContainer, searchRequestModel: SearchRequestModel, screenState: ScreenState) -> Module<DetailedTransition, UIViewController> {
        let viewModel = DetailedViewModel(requestModel: searchRequestModel, screenState: screenState)
        let viewController = DetailedViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
