//
//  AdPhotosViewModel.swift
//  RomaMVVM
//
//  Created by User on 25.05.2023.
//

import Combine
import Foundation

final class AdPhotosViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AdPhotosTransition, Never>()
    
    private let model: AdCreatingModel
    
     init(model: AdCreatingModel) {
        self.model = model
        super.init()
    }
    
    func popScreen() {
        transitionSubject.send(.pop)
    }
    
    func addImages(_ images: [Data]) {
        model.addImages(images)
    }
    
    func createAd() {
        model.createAd()
    }
}
