//
//  AuthCoordinator.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import Combine
import UIKit

final class AuthCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let container: AppContainer
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        signIn()
    }

    deinit {
        print("Deinit of \(String(describing: self))")
    }

    private func signIn() {
        let module = SignInModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .success:
                    didFinishSubject.send()
                    didFinishSubject.send(completion: .finished)
                case .forgotPassword:
                    forgotPassword()
                case .signUp:
                    signUp()
                }
            }
            .store(in: &cancellables)
        setRoot([module.viewController])
    }

    private func signUp() {
        let module = SignUpModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .success:
                    didFinishSubject.send()
                    didFinishSubject.send(completion: .finished)
                case .popScreen:
                    self.pop()
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
    }

    private func forgotPassword() {
        let module = PasswordRestoreModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transiton in
                switch transiton {
                case .success:
                    didFinishSubject.send()
                    didFinishSubject.send(completion: .finished)
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
    }
}
