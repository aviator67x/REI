//
//  SearchViewModel.swift
//  RomaMVVM
//
//  Created by User on 24.03.2023.
//

import Combine
import Foundation

final class SearchFiltersViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SearchFiltersTransition, Never>()

    @Published var screenConfiguration = 0
    @Published private(set) var sections: [SearchFiltersCollection] = []

    private lazy var minPriceSubject = CurrentValueSubject<String?, Never>(nil)
    private lazy var maxPriceSubject = CurrentValueSubject<String?, Never>(nil)
    private lazy var minSquareSubject = CurrentValueSubject<String?, Never>(nil)
    private lazy var maxSquareSubject = CurrentValueSubject<String?, Never>(nil)

    private let model: SearchModel

    init(model: SearchModel) {
        self.model = model
        super.init()
    }

    override func onViewDidLoad() {
        setupBinding()
        updateDataSource()
    }

    private func setupBinding() {
        minPriceSubject
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, price) in
                self.model.updateSearchRequestModel(minPrice: price)
            })
            .store(in: &cancellables)

        maxPriceSubject
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, price) in
                self.model.updateSearchRequestModel(maxPrice: price)
            })
            .store(in: &cancellables)

        minSquareSubject
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, square) in
                self.model.updateSearchRequestModel(minSquare: square)
            })
            .store(in: &cancellables)

        maxSquareSubject
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, square) in
                self.model.updateSearchRequestModel(maxSquare: square)
            })
            .store(in: &cancellables)
    }

    func configureScreen(for index: Int) {
        screenConfiguration = index
    }

    func updateDistance(_ distance: String) {
        model.updateSearchRequestModel(distance: distance)
    }

    func updateType(_ type: String) {
        model.updateSearchRequestModel(propertyType: type)
    }

    func updateNumberOfRooms(_ number: String) {
        model.updateSearchRequestModel(roomsNumber: number)
       
    }

    func executeSearch() {
        model.executeSearch()
        transitionSubject.send(.pop)
    }

    func showDetailed(state: SearchFiltersDetailedScreenState) {
        transitionSubject.send(.detailed(self.model, state))
    }

    func popModule() {
        transitionSubject.send(.pop)
    }

    private func updateDataSource() {
        let segmentControlSection: SearchFiltersCollection = {
            SearchFiltersCollection(sections: .segmentControl, items: [.segmentControl])
        }()

        let distanceSection: SearchFiltersCollection = {
            SearchFiltersCollection(
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

        let priceSection: SearchFiltersCollection = {
            let model = PriceCellModel(minPrice: minPriceSubject, maxPrice: maxPriceSubject)
            return SearchFiltersCollection(sections: .price, items: [.price(model: model)])
        }()

        let yearSection: SearchFiltersCollection = {
            SearchFiltersCollection(sections: .year, items: [.year])
        }()

        let squareSection: SearchFiltersCollection = {
            let model = SquareCellModel(minSquare: minSquareSubject, maxSquare: maxSquareSubject)
            return SearchFiltersCollection(sections: .square, items: [.square(model: model)])
        }()

        let garageSection: SearchFiltersCollection = {
            SearchFiltersCollection(sections: .garage, items: [.garage])
        }()

        let roomsNumberSection: SearchFiltersCollection = {
            SearchFiltersCollection(
                sections: .roomsNumber,
                items: [
                    .roomsNumber("1+"),
                    .roomsNumber("2+"),
                    .roomsNumber("3+"),
                    .roomsNumber("4+"),
                    .roomsNumber("5+"),
                ]
            )
        }()

        let typeSection: SearchFiltersCollection = {
            SearchFiltersCollection(
                sections: .type,
                items: [
                    .type("appartment"),
                    .type("house"),
                    .type("land"),
                ]
            )
        }()

        let backgroundSection: SearchFiltersCollection = {
            SearchFiltersCollection(sections: .backgroundItem, items: [.backgroundItem])
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
            backgroundSection,
        ]
    }
}
