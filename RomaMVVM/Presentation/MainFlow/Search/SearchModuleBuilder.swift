//
//  SearchModuleBuilder.swift
//  RomaMVVM
//
//  Created by User on 24.03.2023.
//

import UIKit
import Combine

enum SearchTransition: Transition {
    
}

final class SearchModuleBuilder {
    class func build(container: AppContainer) -> Module<SearchTransition, UIViewController> {
        let viewModel = SearchViewModel()
        let viewController = SearchViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
