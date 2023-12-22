//
//  HomeCoordinator.swift
//  REI
//
//  Created by user on 28.11.2021.
//

import UIKit
import Combine

final class FavouriteCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private let container: AppContainer
    private var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        searchRoot()
    }

    private func searchRoot() {
        let module = FavouriteModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case let .selectedHouse(house):
                    selectedHouse(house)
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }
    
    private func selectedHouse(_ house: HouseDomainModel) {
        let detailCoordinator = DetaileHouseCoordinator(
            navigationController: navigationController,
            container: container,
            house: house
        )
        childCoordinators.append(detailCoordinator)
        detailCoordinator.didFinishPublisher
            .sink { [unowned self] in
                removeChild(coordinator: detailCoordinator)
            }
            .store(in: &cancellables)
        detailCoordinator.start()
    }
}
