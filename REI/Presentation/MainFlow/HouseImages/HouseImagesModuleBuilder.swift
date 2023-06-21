//
//  HouseImagesModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 06.06.2023.
//

import UIKit
import Combine

enum HouseImagesTransition: Transition {
    case popScreen
}

final class HouseImagesModuleBuilder {
    class func build(container: AppContainer, images: [URL]) -> Module<HouseImagesTransition, UIViewController> {
        let viewModel = HouseImagesViewModel(images: images)
        let viewController = HouseImagesViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
