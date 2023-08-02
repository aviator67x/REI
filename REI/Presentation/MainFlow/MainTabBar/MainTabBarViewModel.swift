//
//  MainTabBarViewModel.swift
//  REI
//
//  Created by user on 28.11.2023.
//

import Combine

final class MainTabBarViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<MainTabBarTransition, Never>()
}
