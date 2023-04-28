//
//  FavouriteViewModel.swift
//  RomaMVVM
//
//  Created by User on 27.04.2023.
//

import Combine

final class FavouriteViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<FavouriteTransition, Never>()
    
    override init() {

        super.init()
    }
    
}
