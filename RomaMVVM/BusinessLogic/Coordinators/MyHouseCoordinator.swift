//
//  MyHouseCoordinator.swift
//  RomaMVVM
//
//  Created by User on 27.04.2023.
//

import Combine
import UIKit

final class MyHouseCoordinator: Coordinator {
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
        myHouseRoot()
    }
    
    private func  myHouseRoot() {
        let module = MyHouseModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                moveToAdCreating()
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }
    
    private func moveToAdCreating() {
        
    }
}

