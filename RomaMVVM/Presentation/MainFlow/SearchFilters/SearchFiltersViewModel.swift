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

    private var searchParameters: [SearchParam] = []
    private var searchRequest: SearchRequestModel {
        didSet {
            print("SearchRequest for now is: \(searchRequest)")
        }
    }
    
    let housesService: HousesService
    
    init(searchRequest: SearchRequestModel, housesService: HousesService) {
        self.searchRequest = searchRequest
        self.housesService = housesService
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
                self.searchRequest.minPrice = price
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
            })
            .store(in: &cancellables)

        maxSquareSubject
            .unwrap()
            .sinkWeakly(self, receiveValue: { (self, square) in
                self.searchRequest.maxSquare = square
            })
            .store(in: &cancellables)
    }

    func configureScreen(for index: Int) {
        screenConfiguration = index
    }

    func updateDistance(_ distance: String) {
        searchRequest.distance = distance
        let distanceParam = SearchParam(
            key: .distance,
            value: .equalToString(parameter: distance))
        searchParameters.append(distanceParam)
    }

    func updateType(_ type: String) {
        searchRequest.propertyType = type
        let typeParam = SearchParam(
            key: .propertyType,
            value: .equalToString(parameter: type))
        searchParameters.append(typeParam)
    }

    func updateNumberOfRooms(_ number: String) {
        searchRequest.roomsNumber = number
        guard let character = number.first,
            let number = Int(String(character)) else { return }
        let roomsNumberParam = SearchParam(
            key: .roomsNumber,
            value: .equalToInt(parameter: number))
    }

    func executeSearch() {
        if searchRequest.garage != nil {
            searchRequest
        }
        housesService.searchHouses(searchParameters)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }, receiveValue: { [unowned self] houses in
                print(houses.count)
            })
            .store(in: &cancellables)
    }

    func showDetailed(state: SearchFiltersDetailedScreenState) {
        transitionSubject.send(.detailed(searchRequest, state))
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
