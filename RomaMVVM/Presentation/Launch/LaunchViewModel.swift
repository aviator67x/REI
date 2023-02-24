//
//  LaunchViewModel.swift
//  RomaMVVM
//
//  Created by User on 24.02.2023.
//

import Combine

final class LaunchViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<LaunchTransition, Never>()
    
    override init() {

        super.init()
    }
    func showTestModule() {
        transitionSubject.send(.testModule)
    }
}
