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
        //        authSelect()
        signIn()
    }
    
    deinit {
        print("Deinit of \(String.init(describing: self))")
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
                case .testSignUp:
                    testSignUp()                
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
    }

    private func testSignUp() {
        let module = TestSignUpModuleModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .success: didFinishSubject.send()
                    didFinishSubject.send(completion: .finished)
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
                case .success: didFinishSubject.send()
                    didFinishSubject.send(completion: .finished)
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
    }

    private func mainFlow() {
        let mainCoordinator = MainTabBarCoordinator(
            navigationController: navigationController,
            container: container
        )
        childCoordinators.append(mainCoordinator)
        mainCoordinator.didFinishPublisher
            .sink { [unowned self] in
                signIn()
                removeChild(coordinator: mainCoordinator)
            }
            .store(in: &cancellables)
        mainCoordinator.start()
    }
    
    private func authSelect() {
        let module = AuthSelectModuleBuilder.build()
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .signIn: signIn()
                case .signUp: signUp()
                case .skip: didFinishSubject.send()
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
    }
    
    
    private func signUp() {
        let module = SignUpModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .success: didFinishSubject.send()
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
    }
}
