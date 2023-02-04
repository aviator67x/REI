//
//  TestSignUpModuleViewModel.swift
//  RomaMVVM
//
//  Created by User on 03.02.2023.
//

import Combine

final class TestSignUpModuleViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<TestSignUpModuleTransition, Never>()
    
    private let instaService: InstaService
    
    init(instaService: InstaService) {
        self.instaService = instaService
        super.init()
    }
    
}
