//
//  AdCreatingViewModel.swift
//  RomaMVVM
//
//  Created by User on 15.05.2023.
//

import Combine

final class AdCreatingViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AdCreatingTransition, Never>()
    
    override init() {

        super.init()
    }
    
}
