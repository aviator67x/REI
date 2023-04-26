//
//  HomeCoordinator.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import UIKit
import Combine

final class SearchCoordinator: Coordinator {
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
        searchRoot()
    }

    private func searchRoot() {
        let module = SearchModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .detailed(let requestModel, let state):
                    year(model: requestModel, screenState: state)
                    didFinishSubject.send()
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }
    
    private func year(model: SearchRequestModel, screenState: ScreenState) {
        let module = DetailedModuleBuilder.build(container: container, searchRequestModel: model, screenState: screenState)
        push(module.viewController)
    }
}
