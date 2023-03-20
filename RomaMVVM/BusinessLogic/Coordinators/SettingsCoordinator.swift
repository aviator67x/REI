//
//  SettingsCoordinator.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import UIKit
import Combine

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

    func start() {
        settingsRoot()
    }

    private func settingsRoot() {
        let module = SettingsModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .property:
                    property()
                case .profile:
                    profile()
                case .terms:
                    terms()
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }
    
    private func property() {
        let module = PropertyModuleBuilder.build(container: container)
        setRoot(module.viewController)
    }
    
    private func  profile() {
        let module = ProfileModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .logout:
                    didFinishSubject.send()
                case .showName:
                    name()
                case .showEmail:
                    email()
                case .showBirth:
                    birth()
                case .showPassword:
                    password()
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
    }
    
    private func terms() {
        let module = TermsModuleBuilder.build(container: container)
        push(module.viewController)
    }
    
    private func name() {
        let module = NameModuleBuilder.build(container: container)
        push(module.viewController)
    }
    
    private func email() {
        let module = EmailModuleBuilder.build(container: container)
        push(module.viewController)
    }
    
    private func birth() {
        let module = BirthModuleBuilder.build(container: container)
        push(module.viewController)
    }
    
    private func password() {
        let module = PasswordModuleBuilder.build(container: container)
        push(module.viewController)
    }
}
