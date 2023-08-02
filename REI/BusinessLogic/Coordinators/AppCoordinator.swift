//
//  AppCoordinator.swift
//  REI
//
//  Created by user on 28.11.2021.
//

import Combine
import UIKit

final class AppCoordinator: Coordinator {
    var window: UIWindow
    var navigationController: UINavigationController
    let container: AppContainer

    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    var childCoordinators: [Coordinator] = []

    private var cancellables = Set<AnyCancellable>()

    init(
        window: UIWindow,
        container: AppContainer,
        navigationController: UINavigationController = UINavigationController()
    ) {
        self.window = window
        self.container = container
        self.navigationController = navigationController
    }

    func start() {
//        let vm = LoremIpsumViewModel(state: .blueprint)
//        let vc = LoremIpsumViewController(viewModel: vm)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

//        container.userService.tokenStorageService.clearAccessToken()
        container.userService.isAuthorized ? mainFlow() : authFlow()
    }

    private func authFlow() {
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            container: container
        )
        childCoordinators.append(authCoordinator)
        authCoordinator.didFinishPublisher
            .sink { [unowned self] in
                mainFlow()
                removeChild(coordinator: authCoordinator)
            }
            .store(in: &cancellables)
        authCoordinator.start()
    }

    private func mainFlow() {
        let mainCoordinator = MainTabBarCoordinator(
            navigationController: navigationController,
            container: container
        )
        childCoordinators.append(mainCoordinator)
        mainCoordinator.didFinishPublisher
            .sink { [unowned self] in
                authFlow()
                removeChild(coordinator: mainCoordinator)
            }
            .store(in: &cancellables)
        mainCoordinator.start()
    }
}