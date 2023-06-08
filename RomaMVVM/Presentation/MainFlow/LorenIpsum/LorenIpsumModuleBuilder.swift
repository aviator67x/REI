//
//  LorenIpsumModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 07.06.2023.
//

import UIKit
import Combine

enum LoremIpsumTransition: Transition {
    case popScreen
}

final class LoremIpsumModuleBuilder {
    class func build(container: AppContainer, state: LoremState) -> Module<LoremIpsumTransition, UIViewController> {
        let viewModel = LoremIpsumViewModel(state: state)
        let viewController = LoremIpsumViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
