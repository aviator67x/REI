//
//  PropertyCoordinator.swift
//  RomaMVVM
//
//  Created by User on 06.03.2023.
//

import Combine
import UIKit

final class SearchResultsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()

    private let container: AppContainer
    private var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        findRoot()
    }

    private func findRoot() {
        let module = SearchResultsModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .searchFilters(let model):
                    let searchFiltersModule = SearchFiltersModuleBuilder.build(container: container, model: model)
                    let searchFiltersController = searchFiltersModule.viewController
                    searchFiltersModule.transitionPublisher
                        .sink { [unowned self] transition in
                            switch transition {
                            case let .detailed(requestModel, state):
                                year(model: requestModel, screenState: state)
                            case .pop:
                                searchFiltersController.navigationController?.popViewController(animated: false)
                            }
                        }
                        .store(in: &cancellables)
                   
                    searchFiltersController.hidesBottomBarWhenPushed = true
                    push(searchFiltersController, animated: false)
                case .sort:
                    break
                case .favourite:
                    let fovouriteModule = FavouriteModuleBuilder.build(container: container)
                    push(fovouriteModule.viewController, animated: false)
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }

    private func year(model: SearchModel, screenState: SearchFiltersDetailedScreenState) {
        let module = SearchFiltersDetailedModuleBuilder.build(
            container: container,
            model: model,
            screenState: screenState
        )
        push(module.viewController)
    }
}