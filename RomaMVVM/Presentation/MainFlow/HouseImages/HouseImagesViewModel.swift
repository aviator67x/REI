//
//  HouseImagesViewModel.swift
//  RomaMVVM
//
//  Created by User on 06.06.2023.
//

import Combine

final class HouseImagesViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<HouseImagesTransition, Never>()
    
   override init() {

        super.init()
    }
    
}
