//
//  TermsViewModel.swift
//  REI
//
//  Created by User on 20.03.2023.
//

import Combine

final class TermsViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<TermsTransition, Never>()
    
    // MARK: - Life cycle
   override init() {

        super.init()
    }
    
}
