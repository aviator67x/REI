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
    
    func setupBinding() {
        model.houseRequestModelPublisher
            .sinkWeakly(self, receiveValue: { (self, adRequestModel) in
                self.adModelSubject.send(adRequestModel)
            })
                .store(in: &cancellables)
    }
    
    func moveToAdPhoto() {
        transitionSubject.send(.showAdPhoto(moodel: model))
    }
    
    func moveToType() {
        self.transitionSubject.send(.type(model: model, screenState: .type))
    }
    
    func moveToNumber() {
        self.transitionSubject.send(.number(model: model, screenState: .number))
    }
    
    func moveToYear() {
        self.transitionSubject.send(.year(model: model, screenState: .year))
    }
    
    func moveToGarage() {
        self.transitionSubject.send(.garage(model: model, screenState: .garage))
    }
    
    func moveToLivingArea() {
        self.transitionSubject.send(.livingArea(model: model, screenState: .livingArea))
    }
    
    func moveToSquare() {
        self.transitionSubject.send(.square(model: model, screenState: .square))
    }
    
    func moveToPrice() {
        self.transitionSubject.send(.price(model: model, screenState: .price))
    }
    
    func popScreen() {
        self.transitionSubject.send(.popScreen)
    }
}
