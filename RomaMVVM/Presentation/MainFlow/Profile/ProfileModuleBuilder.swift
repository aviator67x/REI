//
//  ProfileModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 20.03.2023.
//

import UIKit
import Combine

enum ProfileTransition: Transition {
    
}

final class ProfileModuleBuilder {
    class func build(container: AppContainer) -> Module<ProfileTransition, UIViewController> {
        let viewModel = ProfileViewModel()
        let viewController = ProfileViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
