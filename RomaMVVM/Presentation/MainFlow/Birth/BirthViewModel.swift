//
//  BirthViewModel.swift
//  RomaMVVM
//
//  Created by User on 20.03.2023.
//

import Combine

final class BirthViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<BirthTransition, Never>()
    
   override init() {

        super.init()
    }
    
}