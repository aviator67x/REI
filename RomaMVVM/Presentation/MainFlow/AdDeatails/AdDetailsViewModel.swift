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
    
    let model: AdCreatingModel
    
    init(model: AdCreatingModel) {
        self.model = model
        super.init()
    }
    func moveBack() {
        self.transitionSubject.send(.back)
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
}
