//
//  MainTabBarCoordinator.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import Combine
import UIKit

final class MainTabBarCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    private let container: AppContainer

    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        setupHomeCoordinator()
        setupSettingsCoordinator()
        setupProperyeCoordinator()

        let controllers = childCoordinators.compactMap { $0.navigationController }
        let module = MainTabBarModuleBuilder.build(viewControllers: controllers)
        setRoot(module.viewController)
    }

    private func setupHomeCoordinator() {
        let navController = UINavigationController()
        navController.tabBarItem = .init(
            title: Localization.home,
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass.circle")
        )
        let coordinator = SearchCoordinator(navigationController: navController, container: container)
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    private func setupSettingsCoordinator() {
        let navController = UINavigationController()
        navController.tabBarItem = .init(
            title: Localization.settings,
            image: UIImage(systemName: "gear"),
            selectedImage: nil
        )
        let coordinator = SettingsCoordinator(navigationController: navController, container: container)
        childCoordinators.append(coordinator)
        coordinator.didFinishPublisher
            .sink { [unowned self] in
                childCoordinators.forEach { removeChild(coordinator: $0) }
                didFinishSubject.send()
                didFinishSubject.send(completion: .finished)
            }
            .store(in: &cancellables)
        coordinator.start()
    }
    
    func setupProperyeCoordinator() {
        let navController = UINavigationController()
        navController.tabBarItem = .init(
            title: "Property",
            image: UIImage(systemName: "house.circle"),
            selectedImage: nil
        )
        let coordinator = PropertyCoordinator(navigationController: navController, container: container)
        childCoordinators.append(coordinator)
        coordinator.didFinishPublisher
            .sink { [unowned self] in
                childCoordinators.forEach {
                    removeChild(coordinator: $0)
                }
                didFinishSubject.send()
                didFinishSubject.send(completion: .finished)
            }
            .store(in: &cancellables)
        coordinator.start()
    }
}
