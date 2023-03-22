//
//  ChooseImageViewModel.swift
//  RomaMVVM
//
//  Created by User on 21.03.2023.
//

import Combine

final class ChooseImageViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<ChooseImageTransition, Never>()
    
   override init() {

        super.init()
    }
    
}
