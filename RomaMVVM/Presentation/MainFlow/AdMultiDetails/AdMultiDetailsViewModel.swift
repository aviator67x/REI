//
//  AdMultiDetailsViewModel.swift
//  RomaMVVM
//
//  Created by User on 22.05.2023.
//

import Combine

final class AdMultiDetailsViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AdMultiDetailsTransition, Never>()

    let model: AdCreatingModel
    let screenState: AdMultiDetailsScreenState

    init(model: AdCreatingModel, screenState: AdMultiDetailsScreenState) {
        self.model = model
        self.screenState = screenState
        super.init()
    }
}
