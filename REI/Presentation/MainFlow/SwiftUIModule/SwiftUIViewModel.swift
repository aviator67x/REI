//
//  SwiftUIViewModel.swift
//  REI
//
//  Created by User on 14.08.2023.
//

import Combine

final class SwiftUIViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SwiftUITransition, Never>()
    
    override init() {

        super.init()
    }
    
}
