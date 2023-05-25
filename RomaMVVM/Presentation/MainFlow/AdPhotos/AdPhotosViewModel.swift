//
//  AdPhotosViewModel.swift
//  RomaMVVM
//
//  Created by User on 25.05.2023.
//

import Combine

final class AdPhotosViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AdPhotosTransition, Never>()
    
    override init() {

        super.init()
    }
    
    func popScreen() {
        transitionSubject.send(.pop)
    }
}
