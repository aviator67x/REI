//
//  HomeModuleBuilder.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 20.11.2021.
//

import UIKit
import Combine

enum HomeTransition: Transition {
    case screen1
    case screen2
    case screen3
    case logout
}

final class HomeModuleBuilder {
//    class func build(container: AppContainer) ->  Module<HomeTransition, UIViewController> {
    class func build(container: AppContainer) ->  Module<SearchTransition, UIViewController> {
        let viewModel = SearchViewModel(searchRequest: container.searchRequestModel)// HomeViewModel(userService: container.userService)
        let viewController = SearchViewController(viewModel: viewModel)// HomeViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
