//
//  PropertyCoordinator.swift
//  REI
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
                case let .searchFilters(model):
                    self.searchFilters(model: model)
                case .sort:
                    break
                case .favourite:
                    self.favourite()
                case let .selectedHouse(house):
                    self.selectedHouse(house)
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }

    private func favourite() {
        let fovouriteModule = FavouriteModuleBuilder.build(container: container)
        push(fovouriteModule.viewController, animated: false)
    }

    private func searchFilters(model: SearchModel) {
        let searchFiltersModule = SearchFiltersModuleBuilder.build(container: container, model: model)
        let searchFiltersController = searchFiltersModule.viewController
        searchFiltersModule.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case let .detailed(requestModel, state):
                    year(model: requestModel, screenState: state)
                case .pop:
                    self.pop()
                }
            }
            .store(in: &cancellables)

        searchFiltersController.hidesBottomBarWhenPushed = true
        push(searchFiltersController, animated: false)
    }

    private func year(model: SearchModel, screenState: SearchFiltersDetailedScreenState) {
        let module = SearchFiltersDetailedModuleBuilder.build(
            container: container,
            model: model,
            screenState: screenState
        )
        push(module.viewController)
    }
    
    private func selectedHouse(_ house: HouseDomainModel) {
        let detailCoordinator = DetaileHouseCoordinator(navigationController: navigationController, container: container, house: house)
        childCoordinators.append(detailCoordinator)
        detailCoordinator.didFinishPublisher
            .sink { [unowned self] in
                removeChild(coordinator: detailCoordinator)
            }
            .store(in: &cancellables)
        detailCoordinator.start()
    }
}
