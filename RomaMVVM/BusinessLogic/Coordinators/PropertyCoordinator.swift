//
//  PropertyCoordinator.swift
//  RomaMVVM
//
//  Created by User on 06.03.2023.
//

import UIKit
import Combine

final class PropertyCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    
    private let container: AppContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        propertyRoot()
    }
    
    private func  propertyRoot() {
        let module = PropertyModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .home:
                    didFinishSubject.send()
                    didFinishSubject.send(completion: .finished)
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }
}
