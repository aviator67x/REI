//
//  LorenIpsumViewModel.swift
//  RomaMVVM
//
//  Created by User on 07.06.2023.
//

import Combine

final class LoremIpsumViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<LoremIpsumTransition, Never>()
    
    private(set) lazy var screenStatePublisher = screenStateSubject.eraseToAnyPublisher()
    private lazy var screenStateSubject = CurrentValueSubject<LoremState, Never>(.blueprint)
    
   init(state: LoremState) {
        super.init()
       self.screenStateSubject.value = state
    }
    
    override func onViewDidLoad() {
        setupBinding()
    }
    
    private func setupBinding() {
        
    }
    
    func popScreen() {
        transitionSubject.send(.popScreen)
    }
}
