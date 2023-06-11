//
//  AdDetailsViewModel.swift
//  RomaMVVM
//
//  Created by User on 22.05.2023.
//

import Combine

final class AdDetailsViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AdDetailsTransition, Never>()
    
    private(set) lazy var adModelPublisher = adModelSubject.eraseToAnyPublisher()
    private lazy var adModelSubject = PassthroughSubject<AdCreatingRequestModel, Never>()
    
    let model: AdCreatingModel
    
    init(model: AdCreatingModel) {
        self.model = model
        super.init()
    }
    
    override func onViewDidLoad() {
        setupBinding()
    }
    
    func moveToAdPhoto() {
        transitionSubject.send(.showAdPhoto(moodel: model))
    }
    
    func updateAdCreatingRequestModel(propertyType: String) {
        model.updateAdCreatingRequestModel(type: propertyType)
    }
    
    func updateAdCreatingRequestModel(numbeOfRoooms: String) {
        guard let number = Int(numbeOfRoooms) else {
            return
        }
        model.updateAdCreatingRequestModel(number: number)
    }
    
    func updateAdCreatingRequestModel(constructionYear: String) {
        guard let number = Int(constructionYear) else {
            return
        }
        model.updateAdCreatingRequestModel(year: number)
    }
    
    func updateAdCreatingRequestModel(parkingType: String) {
        model.updateAdCreatingRequestModel(garage: parkingType)
    }
    
    func updateAdCreatingRequestModel(livingArea: String) {
        guard let area = Int(livingArea) else {
            return
        }
        model.updateAdCreatingRequestModel(livingArea: area)
    }
    
    func updateAdCreatingRequestModel(square: String) {
        guard let square = Int(square) else {
            return
        }
        model.updateAdCreatingRequestModel(square: square)
    }
    
    func updateAdCreatingRequestModel(price: String) {
        guard let price = Int(price) else {
            return
        }
        model.updateAdCreatingRequestModel(price: price)
    }
    
    func moveToMyHouse() {
        self.transitionSubject.send(.myHouse)
    }
    
    func popScreen() {
        self.transitionSubject.send(.popScreen)
    }
}

// MARK: - private extension
private extension AdDetailsViewModel {
    func setupBinding() {
        model.adCreatingRequestModelPublisher
            .sinkWeakly(self, receiveValue: { (self, adRequestModel) in
                self.adModelSubject.send(adRequestModel)
            })
                .store(in: &cancellables)
    }
}
