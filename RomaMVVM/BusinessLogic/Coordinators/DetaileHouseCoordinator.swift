//
//  DetaileHouseCoordinator.swift
//  RomaMVVM
//
//  Created by User on 09.06.2023.
//

import Combine
import UIKit

final class DetaileHouseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    
    private let house: HouseDomainModel
    private let container: AppContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController, container: AppContainer, house: HouseDomainModel) {
        self.house = house
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        rootDetail()
    }
    
    private func rootDetail() {
        let module = SelectedHouseModuleBuilder.build(container: container, house: house)
        module.transitionPublisher
            .sinkWeakly(self, receiveValue: { (self, transition) in
                switch transition {
                case let .showHouse(images: images):
                    self.houseImages(images)
                case .moveToBlueprint(let state):
                    self.lorem(state)
                }
            })
            .store(in: &cancellables)
        push(module.viewController)
    }

    private func houseImages(_ images: [URL]) {
        let module = HouseImagesModuleBuilder.build(container: container, images: images)
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
    
    private func lorem(_ state: LoremState) {
        let module = LoremIpsumModuleBuilder.build(container: container, state: .blueprint)
        module.transitionPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.pop()
            })
            .store(in: &cancellables)
        push(module.viewController)
    }

}

