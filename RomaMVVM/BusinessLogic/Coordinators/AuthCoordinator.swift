//
//  AuthCoordinator.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import UIKit
import Combine

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
//        startTestModule()
        launch()
    }
    
    func launch() {
        let module = LaunchModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transitionValue in
                switch transitionValue {
                case .signIn: startTestModule()
                case .testModule: startTestModule()             
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
        
    }
    
    func startTestModule() {
        let module = TestModuleModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transitionValue in
                switch transitionValue {
                case .signUp: print("signUp")
                    signUp()
                case .forgotPassword:
                    print("forgotPassword")
                case .testSignUp:
                    testSignUp()
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
    }

    private func authSelect() {
        let module = AuthSelectModuleBuilder.build()
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .signIn:   signIn()
                case .signUp:   signUp()
                case .skip:     didFinishSubject.send()
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
    }

    private func signIn() {
        let module = SignInModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .success: didFinishSubject.send()
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
    
    private func testSignUp() {
        let module = TestSignUpModuleModuleBuilder.build(container: container)
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
