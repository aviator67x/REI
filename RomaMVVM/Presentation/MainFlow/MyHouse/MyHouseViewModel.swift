//
//  MyHouseViewModel.swift
//  RomaMVVM
//
//  Created by User on 27.04.2023.
//

import Combine

final class MyHouseViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<MyHouseTransition, Never>()
    
   override init() {

        super.init()
    }
    
    func moveToNextAd() {
        transitionSubject.send(.moveToAdCreating)
    }
}
