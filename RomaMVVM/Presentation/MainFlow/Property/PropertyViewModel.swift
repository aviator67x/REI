//
//  PropertyViewModel.swift
//  RomaMVVM
//
//  Created by User on 06.03.2023.
//

import Combine

final class PropertyViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<PropertyTransition, Never>()
    
    override init() {

        super.init()
    }
    
}
