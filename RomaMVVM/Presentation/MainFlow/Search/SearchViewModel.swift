//
//  SearchViewModel.swift
//  RomaMVVM
//
//  Created by User on 24.03.2023.
//

import Combine

struct SearchCollection {
    let sections: SearchSection
    let items: [SearchItem]
}

final class SearchViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SearchTransition, Never>()
    
    @Published var screenConfiguration: Int = 0
    
    override init() {
        
        super.init()
    }
    func configureScreen(for index: Int) {
        screenConfiguration = index
    }
}
