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
                case .moveToAdAddress(let model):
                    moveToAdAddress(model: model)
                case .detail(let house):
                    self.showDetail(house)
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }

    private func moveToAdAddress(model: AdCreatingModel) {
        let adAddressModule = AdAddressModuleBuilder.build(container: container, model: model)
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
                    self.details(
                        model: model,
                        screenState: state
                    )

                case let .number(model, state):
                    self.details(
                        model: model,
                        screenState: state
                    )

                case let .year(model, state):
                    self.details(
                        model: model,
                        screenState: state
                    )

                case let .garage(model, state):
                    self.details(
                        model: model,
                        screenState: state
                    )

                case let .livingArea(model, state):
                    self.details(
                        model: model,
                        screenState: state
                    )

                case let .square(model, state):
                    self.details(
                        model: model,
                        screenState: state
                    )

                case let .price(model, state):
                    self.details(
                        model: model,
                        screenState: state
                    )
                case .popScreen:
                    self.pop()
                    
                case .myHouse:
                    self.myHouse()
                }
            })
            .store(in: &cancellables)
        push(module.viewController)
    }
    
    private func myHouse() {
        popToViewController(ofClass: MyHouseViewController.self)
    }

    private func adPhoto(model: AdCreatingModel) {
        let module = AdPhotosModuleBuilder.build(container: container, model: model)
        module.transitionPublisher
            .sinkWeakly(self, receiveValue: { (self, trainsition) in
                switch trainsition {
                case .myHouse:
//                    self.pop()
                    self.myHouse()
                case .popScreen:
                    self.pop()
                }
            })
            .store(in: &cancellables)
        push(module.viewController)
    }

    private func details(model: AdCreatingModel, screenState: AdMultiDetailsScreenState) {
        let module = AdMultiDetailsModuleBuilder.build(container: container, model: model, screenState: screenState)
        module.transitionPublisher
            .sinkWeakly(self, receiveValue: { (self, transition) in
                switch transition {
                case .myHouse:
                    self.myHouse()
                case .popScreen:
                    self.pop()
                }
            })
            .store(in: &cancellables)
        push(module.viewController)
    }
    
    private func showDetail(_ house: HouseDomainModel) {
        let detailCoordinator = DetaileHouseCoordinator(navigationController: navigationController, container: container, house: house)
        childCoordinators.append(detailCoordinator)
        detailCoordinator.didFinishPublisher
            .sink { [unowned self] in
                removeChild(coordinator: detailCoordinator)
            }
            .store(in: &cancellables)
        detailCoordinator.start()
    }
}
