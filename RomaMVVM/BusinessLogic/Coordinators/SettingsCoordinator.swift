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
                case .profile:
                    profile()
                case .terms:
                    terms()
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }
    
    private func  profile() {
        let module = ProfileModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .logout:
                    didFinishSubject.send()
                case .showEditProfile(let configuration):
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
            .sinkWeakly(self, receiveValue: { (self, value) in
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
        let module = PasswordRestoreModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transiton in
                switch transiton {
                case .success:
                    didFinishSubject.send()
                    didFinishSubject.send(completion: .finished)
                case .popScreen:
                    self.pop()
                }
            }
            .store(in: &cancellables)
        let viewController = module.viewController
        viewController.tabBarController?.tabBar.isHidden = true
        push(viewController)
    }
}
