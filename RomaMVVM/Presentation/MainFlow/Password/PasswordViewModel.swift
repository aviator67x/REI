//
//  PasswordViewModel.swift
//  RomaMVVM
//
//  Created by User on 20.03.2023.
//

import Combine

final class PasswordViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<PasswordTransition, Never>()
    
   override init() {

        super.init()
    }
    
}
