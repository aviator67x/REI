//
//  EditProfileModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 22.03.2023.
//

import UIKit
import Combine

enum EditProfileTransition: Transition {
    
}

final class EditProfileModuleBuilder {
    class func build(container: AppContainer) -> Module<EditProfileTransition, UIViewController> {
        let viewModel = EditProfileViewModel()
        let viewController = EditProfileViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
