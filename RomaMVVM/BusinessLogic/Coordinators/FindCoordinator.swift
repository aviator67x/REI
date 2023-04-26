//
//  PropertyCoordinator.swift
//  RomaMVVM
//
//  Created by User on 06.03.2023.
//

import UIKit
import Combine

final class FindCoordinator: Coordinator {
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
        findRoot()
    }
    
    private func  findRoot() {
        let module = FindModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .search:
//                    didFinishSubject.send()
//                    didFinishSubject.send(completion: .finished)
                    let searchModule = SearchModuleBuilder.build(container: container)
                    let controller = searchModule.viewController
                    controller.hidesBottomBarWhenPushed = true
                    push(controller, animated: false)
                case .sort:
                    break
                case .favourite:
                    break
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }
}
