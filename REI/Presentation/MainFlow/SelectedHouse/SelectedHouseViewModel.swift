//
//  SelectedHouseViewModel.swift
//  RomaMVVM
//
//  Created by User on 31.05.2023.
//

import Combine
import Foundation

final class SelectedHouseViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SelectedHouseTransition, Never>()
    
    private(set) lazy var housePublisher = houseSubject.eraseToAnyPublisher()
    private lazy var houseSubject = CurrentValueSubject<SelectedHouseModel?, Never>(nil)
    
    private let house: HouseDomainModel
    private let model: SearchModel
    
    init(model: SearchModel, house: HouseDomainModel) {
        self.model = model
        self.house = house
        super.init()
    }
    
    override func onViewDidLoad() {
        let house = SelectedHouseModel(data: house)
        houseSubject.send(house)
        setupBinding()
    }
    
    
    private func setupBinding() {
        model.favouriteHousesIdPublisher
            .sinkWeakly(self, receiveValue: { (self, ids) in
                self.houseSubject.value?.isFavourite = ids.contains(self.house.id)
            })
            .store(in: &cancellables)
    }
    
    func editFavorites(with id: String) {
        model.editFavouriteHouses(with: id)
    }
    
    func showHouseImages() {
        guard let images = house.images else {
            return
        }
        transitionSubject.send(.showHouse(images: images))
    }
    
    func moveToBlueprint() {
        transitionSubject.send(.moveToBlueprint(.blueprint))
    }
    
    func popScreen() {
        self.transitionSubject.send(.popScreen)
    }
    
    func moveToAllaround() {}
}
