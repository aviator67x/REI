//
//  EditProfileModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 22.03.2023.
//

import Combine
import UIKit

enum EditProfileTransition: Transition {
}

final class EditProfileModuleBuilder {
    class func build(
        container: AppContainer,
        configuration: EditProfileConfiguration
    ) -> Module<EditProfileTransition, UIViewController> {
        let viewModel = EditProfileViewModel(userService: container.userService)
        let viewController = EditProfileViewController(configuration: configuration, viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
