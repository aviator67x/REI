//
//  FindViewModel.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import Combine

final class FindViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<FindTransition, Never>()
    
   override init() {

        super.init()
    }
    
}
