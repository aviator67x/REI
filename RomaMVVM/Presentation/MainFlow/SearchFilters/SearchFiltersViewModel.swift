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

    func updateDistance(_ distance: SearchRequestModel.Distance) {
        model.updateSearchRequestModel(distance: distance)
    }

    func updateType(_ type: SearchRequestModel.PropertyType) {
        model.updateSearchRequestModel(propertyType: type)
    }

    func updateNumberOfRooms(_ number: SearchRequestModel.NumberOfRooms) {
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
                    .distance(.one),
                    .distance(.two),
                    .distance(.five),
                    .distance(.ten),
                    .distance(.fifteen),
                    .distance(.thirty),
                    .distance(.fifty),
                    .distance(.oneHundred),
                ]
            )
        }()

        let priceSection: SearchFiltersCollection = {
            let model = PriceCellModel(minPrice: minPriceSubject, maxPrice: maxPriceSubject)
            return SearchFiltersCollection(sections: .price, items: [.price(model: model)])
        }()

        let yearSection: SearchFiltersCollection = {
            SearchFiltersCollection(sections: .year, items: [.year(.since1850)])
        }()

        let squareSection: SearchFiltersCollection = {
            let model = SquareCellModel(minSquare: minSquareSubject, maxSquare: maxSquareSubject)
            return SearchFiltersCollection(sections: .square, items: [.square(model: model)])
        }()

        let garageSection: SearchFiltersCollection = {
            SearchFiltersCollection(sections: .garage, items: [.garage(.garage)])
        }()

        let roomsNumberSection: SearchFiltersCollection = {
            SearchFiltersCollection(
                sections: .roomsNumber,
                items: [
                    .roomsNumber(.one),
                    .roomsNumber(.two),
                    .roomsNumber(.three),
                    .roomsNumber(.four),
                    .roomsNumber(.five),
                ]
            )
        }()

        let typeSection: SearchFiltersCollection = {
            SearchFiltersCollection(
                sections: .type,
                items: [
                    .type(.apartment),
                    .type(.house),
                    .type(.land),
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
