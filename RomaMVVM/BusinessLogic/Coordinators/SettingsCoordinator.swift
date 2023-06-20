//
//  SettingsCoordinator.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import Combine
import UIKit

final class SettingsCoordinator: Coordinator {
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
    
    deinit {
        debugPrint("deinit of", String(describing: self))
    }

    func start() {
        settingsRoot()
    }

    private func settingsRoot() {
        let module = SettingsModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .profile:
                    profile()
                case .terms:
                    terms()
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }

    private func profile() {
        let module = ProfileModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .logout:
                    didFinishSubject.send()
                case let .showEditProfile(configuration):
                    editProfile(configuration)
                case .showPassword:
                    password()
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
    }

    private func terms() {
        let module = LoremIpsumModuleBuilder.build(container: container, state: .text)
        module.transitionPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.pop()
            })
            .store(in: &cancellables)
        push(module.viewController)
    }

    private func editProfile(_ configuration: EditProfileConfiguration) {
        let module = EditProfileModuleBuilder.build(container: container, configuration: configuration)
        push(module.viewController)
    }

    private func password() {
        let passwordCoordinator = PasswordCoordinator(navigationController: navigationController, container: container)
        childCoordinators.append(passwordCoordinator)
        passwordCoordinator.didFinishPublisher
            .sink { [unowned self] in
                removeChild(coordinator: passwordCoordinator)
            }
            .store(in: &cancellables)
        passwordCoordinator.start()
    }
}
