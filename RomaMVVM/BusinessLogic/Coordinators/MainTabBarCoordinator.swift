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
        setupFindCoordinator()
        setupFavoriteCoordinator()
        setupMyHouseCoordinator()
        setupSettingsCoordinator()

        let controllers = childCoordinators.compactMap { $0.navigationController }
        let module = MainTabBarModuleBuilder.build(viewControllers: controllers)
        setRoot(module.viewController)
    }

    private func setupFavoriteCoordinator() {
        let navController = UINavigationController()
        navController.tabBarItem = .init(
            title: Localization.favourite,
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.filled")
        )
        let coordinator = FavouriteCoordinator(navigationController: navController, container: container)
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

    func setupFindCoordinator() {
        let navController = UINavigationController()
        navController.tabBarItem = .init(
            title: "Find",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: nil
        )
        let coordinator = FindCoordinator(navigationController: navController, container: container)
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
    
    func setupMyHouseCoordinator() {
        let navController = UINavigationController()
        navController.tabBarItem = .init(
            title: "MyHouse",
            image: UIImage(systemName: "house"),
            selectedImage: nil
        )
        let coordinator = MyHouseCoordinator(navigationController: navController, container: container)
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
