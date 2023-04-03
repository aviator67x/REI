//
//  HomeCoordinator.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import UIKit
import Combine

final class HomeCoordinator: Coordinator {
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
        homeRoot()
    }

    private func homeRoot() {
        let module = HomeModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .logout:
                    didFinishSubject.send()
                case .year(let requestModel):
                    year(model: requestModel)
                    didFinishSubject.send()
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }
    
    private func year(model: SearchRequestModel) {
        let module = ConstructionYearModuleBuilder.build(container: container, searchRequestModel: model)
        push(module.viewController)
    }
}
