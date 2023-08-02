//
//  PasswordCoordinator.swift
//  REI
//
//  Created by User on 18.06.2023.
//

import Combine
import UIKit

final class PasswordCoordinator:Coordinator  {
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
        rootPassword()
    }
    
    private func rootPassword() {
        let module = PasswordRestoreModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transiton in
                switch transiton {
                case .success, .popScreen:
                    self.pop()
                    didFinishSubject.send()
                    didFinishSubject.send(completion: .finished)
                case .finishFow:
                    didFinishSubject.send()
                    didFinishSubject.send(completion: .finished)
                }
            }
            .store(in: &cancellables)
        push(module.viewController)        
    }
}

