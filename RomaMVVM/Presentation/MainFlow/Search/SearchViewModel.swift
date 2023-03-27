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
    @Published private(set) var sections: [SearchCollection] = []
    
    override init() {
        
        super.init()
    }
    
    override func onViewDidLoad() {
        updateDataSource()
    }
    
    func configureScreen(for index: Int) {
        screenConfiguration = index
    }
    
    private func updateDataSource() {
        let distanceSection: SearchCollection = {
           SearchCollection(sections: .distance, items: [.distance])
        }()
        
        let priceSection: SearchCollection = {
            SearchCollection(sections: .price, items: [.price])
        }()
        
        let typeSection: SearchCollection = {
            SearchCollection(sections: .type, items: [.type])
        }()
        
        let squareSection: SearchCollection = {
            SearchCollection(sections: .square, items: [.square])
        }()
        
        let roomsNumberSection: SearchCollection = {
            SearchCollection(sections: .roomsNumber, items: [.roomsNumber])
        }()
        
        let yearSection: SearchCollection = {
            SearchCollection(sections: .year, items: [.year])
        }()
        
        let garageSection: SearchCollection = {
            SearchCollection(sections: .garage, items: [.garage])
        }()
        sections = [distanceSection, priceSection, typeSection, squareSection, roomsNumberSection, yearSection, garageSection]
    }
}
