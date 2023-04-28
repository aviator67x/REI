//
//  SearchViewModel.swift
//  RomaMVVM
//
//  Created by User on 24.03.2023.
//

import Combine
import Foundation

final class SearchViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SearchTransition, Never>()
    
    @Published var screenConfiguration = 0
    @Published private(set) var sections: [SearchCollection] = []
    
    private lazy var minPriceSubject = CurrentValueSubject<String?, Never>(nil)
    private lazy var maxPriceSubject = CurrentValueSubject<String?, Never>(nil)
    private lazy var minSquareSubject = CurrentValueSubject<String?, Never>(nil)
    private lazy var maxSquareSubject = CurrentValueSubject<String?, Never>(nil)
    
    private var searchRequest: SearchRequestModel {didSet {
        print(oldValue.self)
    }}
    
    init(searchRequest: SearchRequestModel) {
        self.searchRequest = searchRequest
        super.init()
        setupBinding()
    }
    
    override func onViewDidLoad() {
        updateDataSource()
    }
    
   private func setupBinding() {
        minPriceSubject
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, price) in
                self.searchRequest.minPrice = price
                print(price)
            })
            .store(in: &cancellables)
        
        maxPriceSubject
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, price) in
                self.searchRequest.maxPrice
                 = price
            })
            .store(in: &cancellables)
        
        minSquareSubject
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, square) in
                self.searchRequest.minSquare = square
                print(square)
            })
            .store(in: &cancellables)
        
        maxSquareSubject
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, square) in
                self.searchRequest.maxSquare = square
                print(square)
            })
            .store(in: &cancellables)
    }
    
    func configureScreen(for index: Int) {
        screenConfiguration = index
    }

    func updateDistance(_ distance: String) {
        print(distance)
        searchRequest.distance = distance
    }

    func updateType(_ type: String) {
        searchRequest.propertyType = type
        print(type)
    }

    func updateNumberOfRooms(_ number: String) {
        searchRequest.roomsNumber = number
        print(number)
    }
    
    func showDetailed(state: ScreenState) {
        transitionSubject.send(.detailed(searchRequest, state))
    }
    
    func popModule() {
        transitionSubject.send(.pop)
    }

    private func updateDataSource() {
        let segmentControlSection: SearchCollection = {
            SearchCollection(sections: .segmentControl, items: [.segmentControl])
        }()

        let distanceSection: SearchCollection = {
            SearchCollection(
                sections: .distance,
                items: [
                    .distance("+ 1"),
                    .distance("+ 2"),
                    .distance("+ 5"),
                    .distance("+ 10"),
                    .distance("+ 15"),
                    .distance("+ 30"),
                    .distance("+ 50"),
                    .distance("+ 100"),
                ]
            )
        }()

        let priceSection: SearchCollection = {
            let model = PriceCellModel(minPrice: minPriceSubject, maxPrice: maxPriceSubject)
            return SearchCollection(sections: .price, items: [.price(model: model)])
        }()

        let yearSection: SearchCollection = {
            SearchCollection(sections: .year, items: [.year])
        }()
        
        let squareSection: SearchCollection = {
            let model = SquareCellModel(minSquare: minSquareSubject, maxSquare: maxSquareSubject)
            return SearchCollection(sections: .square, items: [.square(model: model)])
        }()

        let garageSection: SearchCollection = {
            SearchCollection(sections: .garage, items: [.garage])
        }()

        let roomsNumberSection: SearchCollection = {
            SearchCollection(
                sections: .roomsNumber,
                items: [
                    .roomsNumber("+1"),
                    .roomsNumber("+2"),
                    .roomsNumber("+3"),
                    .roomsNumber("+4"),
                    .roomsNumber("+5"),
                ]
            )
        }()

        let typeSection: SearchCollection = {
            SearchCollection(
                sections: .type,
                items: [
                    .type("appartment"),
                    .type("house"),
                    .type("land"),
                ]
            )
        }()
        
        let backgroundSection: SearchCollection = {
            SearchCollection(sections: .backgroundItem, items: [.backgroundItem])
        }()

        sections = [
            segmentControlSection,
            distanceSection,
            priceSection,
            typeSection,
            squareSection,
            roomsNumberSection,
            yearSection,
            garageSection,
            backgroundSection
        ]
    }
}
