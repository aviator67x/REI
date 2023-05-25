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

    private func myHouseRoot() {
        let module = MyHouseModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .moveToAdAddress:
                    moveToAdAddress()
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }

    private func moveToAdAddress() {
        let adAddressModule = AdAddressModuleBuilder.build(container: container)
        adAddressModule.transitionPublisher
            .sinkWeakly(self, receiveValue: { (self, transition) in
                switch transition {
                case .myHouse:
                    self.pop()
                case let .adDetails(model):
                    self.adDetails(model: model)
                }
            })
            .store(in: &cancellables)
        push(adAddressModule.viewController)
    }

    private func adDetails(model: AdCreatingModel) {
        let module = AdDetailsModuleBuilder.build(container: container, model: model)
        module.transitionPublisher
            .sinkWeakly(self, receiveValue: { (self, trainsition) in
                switch trainsition {
                case let .showAdPhoto(model):
                    self.adPhoto(model: model)
                    
                case let .type(model, state):
                    self.type(
                        model: model,
                        screenState: state
                    )

                case let .number(model, state):
                    self.number(
                        model: model,
                        screenState: state
                    )

                case let .year(model, state):
                    self.year(
                        model: model,
                        screenState: state
                    )

                case let .garage(model, state):
                    self.garage(
                        model: model,
                        screenState: state
                    )
                case .popScreen:
                    self.pop()
                }
            })
            .store(in: &cancellables)
        push(module.viewController)
    }
    
    private func adPhoto(model: AdCreatingModel) {
        let module = AdPhotosModuleBuilder.build(container: container, model: model)
        module.transitionPublisher
            .sinkWeakly(self, receiveValue: { (self, trainsition) in
                switch trainsition {
                case .pop:
                    self.pop()
                }
            })
            .store(in: &cancellables)
        push(module.viewController)
    }

    private func type(model: AdCreatingModel, screenState: AdMultiDetailsScreenState) {
        let module = AdMultiDetailsModuleBuilder.build(container: container, model: model, screenState: screenState)
        module.transitionPublisher
            .sinkWeakly(self, receiveValue: { (self, transition) in
                switch transition {
                case .popScreen:
                    self.pop()
                }
            })
            .store(in: &cancellables)
        push(module.viewController)
    }

    private func number(model: AdCreatingModel, screenState: AdMultiDetailsScreenState) {
        let module = AdMultiDetailsModuleBuilder.build(container: container, model: model, screenState: screenState)
        module.transitionPublisher
            .sinkWeakly(self, receiveValue: { (self, transition) in
                switch transition {
                case .popScreen:
                    self.pop()
                }
            })
            .store(in: &cancellables)
        push(module.viewController)
    }

    private func year(model: AdCreatingModel, screenState: AdMultiDetailsScreenState) {
        let module = AdMultiDetailsModuleBuilder.build(container: container, model: model, screenState: screenState)
        module.transitionPublisher
            .sinkWeakly(self, receiveValue: { (self, transition) in
                switch transition {
                case .popScreen:
                    self.pop()
                }
            })
            .store(in: &cancellables)
        push(module.viewController)
    }

    private func garage(model: AdCreatingModel, screenState: AdMultiDetailsScreenState) {
        let module = AdMultiDetailsModuleBuilder.build(container: container, model: model, screenState: screenState)
        module.transitionPublisher
            .sinkWeakly(self, receiveValue: { (self, transition) in
                switch transition {
                case .popScreen:
                    self.pop()
                }
            })
            .store(in: &cancellables)
        push(module.viewController)
    }
}
