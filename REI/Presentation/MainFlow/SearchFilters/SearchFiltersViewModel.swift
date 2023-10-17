//
//  SearchViewModel.swift
//  REI
//
//  Created by User on 24.03.2023.
//

import Combine
import CoreLocation
import Foundation

final class SearchFiltersViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SearchFiltersTransition, Never>()

    private lazy var screenConfigurationSubject = CurrentValueSubject<Int, Never>(0)

    @Published private(set) var sections: [SearchFiltersCollection] = []

    private(set) lazy var searchRequestModelPublisher = searchRequestModelSubject.eraseToAnyPublisher()
    private lazy var searchRequestModelSubject = CurrentValueSubject<SearchRequestModel, Never>(.init())

    private(set) lazy var filteredHousesCountPublisher = filteredHousesCountSubject.eraseToAnyPublisher()
    private lazy var filteredHousesCountSubject = CurrentValueSubject<Int, Never>(0)

    private lazy var ortSubject = CurrentValueSubject<String, Never>("")
    private var point = ""
    private lazy var minPriceSubject = CurrentValueSubject<String, Never>("")
    private lazy var maxPriceSubject = CurrentValueSubject<String, Never>("")
    private lazy var minSquareSubject = CurrentValueSubject<String, Never>("")
    private lazy var maxSquareSubject = CurrentValueSubject<String, Never>("")

    private let model: SearchModel

    private var propertyTypeCellModels: [PropertyTypeCellModel] = []
    private var distanceCellModels: [DistanceCellModel] = [
        .init(distance: .one),
        .init(distance: .two),
        .init(distance: .five),
        .init(distance: .ten),
        .init(distance: .fifteen),
        .init(distance: .thirty),
        .init(distance: .fifty),
        .init(distance: .oneHundred),
    ]

    private var numberOfRoomsCellModels: [NumberOfRoomsCellModel] = [
        .init(numberOfRooms: .one),
        .init(numberOfRooms: .two),
        .init(numberOfRooms: .three),
        .init(numberOfRooms: .four),
        .init(numberOfRooms: .five),
    ]

    // MARK: - life cycle
    init(model: SearchModel) {
        self.model = model
        super.init()
    }

    override func onViewDidLoad() {
        setupBinding()
        updateDataSource()
    }
}

// MARK: - extension
extension SearchFiltersViewModel {
    func cleanFilters() {
        model.cleanSearchRequestModel()
        ortSubject.value = ""
        minPriceSubject.value = ""
        maxPriceSubject.value = ""
        minSquareSubject.value = ""
        maxSquareSubject.value = ""
        for index in distanceCellModels.indices {
            distanceCellModels[index].isSelected = false
        }
        for index in propertyTypeCellModels.indices {
            propertyTypeCellModels[index].isSelected = false
        }
        for index in numberOfRoomsCellModels.indices {
            numberOfRoomsCellModels[index].isSelected = false
        }
        updateDataSource()
    }

    func configureScreen(for index: Int) {
        screenConfigurationSubject.value = index
    }

    func updateOrt(_ ort: String) {
        ortSubject.value = ort

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(ort, completionHandler: { placemarks, error in
            if error != nil {
                print("Failed to retrieve location")
                return
            }

            var location: CLLocation?

            if let placemarks = placemarks, !placemarks.isEmpty {
                location = placemarks.first?.location
            }

            if let location = location {
                let coordinate = location.coordinate
                self.point = "'POINT(\(coordinate.latitude) \(coordinate.longitude))'"
            } else {
                print("No Matching Location Found")
            }
        })
    }

    func updateDistanceOnSphere(_ distance: DistanceCellModel) {
        for (index, _) in distanceCellModels.enumerated() {
            distanceCellModels[index].isSelected = false
        }
        guard let selectedItemIndex = distanceCellModels.firstIndex(of: distance) else {
            return
        }
        distanceCellModels[selectedItemIndex].isSelected.toggle()
        let stringDistance = String(distance.distance.rawValue)
        let searchParam = ["(location, ", "\(point)", ") <= \(stringDistance)"].joined()
        model.updateSearchRequestModel(distance: searchParam)
        updateDataSource()
    }

    func updateMinPrice(_ min: String) {
        minPriceSubject.value = min
    }

    func updateMaxPrice(_ max: String) {
        maxPriceSubject.value = max
    }

    func updateMinSquare(_ min: String) {
        minSquareSubject.value = min
    }

    func updateMaxSquare(_ max: String) {
        maxSquareSubject.value = max
    }

    func updateType(_ type: PropertyTypeCellModel) {
        for (index, _) in propertyTypeCellModels.enumerated() {
            propertyTypeCellModels[index].isSelected = false
        }
        guard let selectedItemIndex = propertyTypeCellModels.firstIndex(of: type) else {
            return
        }
        propertyTypeCellModels[selectedItemIndex].isSelected.toggle()

        model.updateSearchRequestModel(propertyType: type.propertyType)
        updateDataSource()
    }

    func updateNumberOfRooms(_ number: NumberOfRoomsCellModel) {
        for (index, _) in numberOfRoomsCellModels.enumerated() {
            numberOfRoomsCellModels[index].isSelected = false
        }
        guard let selectedItemIndex = numberOfRoomsCellModels.firstIndex(of: number) else {
            return
        }
        numberOfRoomsCellModels[selectedItemIndex].isSelected.toggle()
        model.updateSearchRequestModel(roomsNumber: number.numberOfRooms)
        updateDataSource()
    }

    func saveSearchParams() {
        model.saveSearchFilters()
    }

    func executeSearch() {
        model.hasFilters ? model.executeSearch() : model.loadHousesAPI()
        transitionSubject.send(.pop)
    }

    func showDetailed(state: SearchFiltersDetailedScreenState) {
        transitionSubject.send(.detailed(model, state))
    }

    func popModule() {
        transitionSubject.send(.pop)
    }
}

// MARK: - private extension
private extension SearchFiltersViewModel {
    func setupBinding() {
        bindDataSource()

        minPriceSubject
            .dropFirst()
            .sinkWeakly(self, receiveValue: { (self, price) in
                self.model.updateSearchRequestModel(minPrice: price)

            })
            .store(in: &cancellables)

        maxPriceSubject
            .dropFirst()
            .sinkWeakly(self, receiveValue: { (self, price) in
                self.model.updateSearchRequestModel(maxPrice: price)

            })
            .store(in: &cancellables)

        minSquareSubject
            .dropFirst()
            .sinkWeakly(self, receiveValue: { (self, square) in
                self.model.updateSearchRequestModel(minSquare: square)
            })
            .store(in: &cancellables)

        maxSquareSubject
            .dropFirst()
            .sinkWeakly(self, receiveValue: { (self, square) in
                self.model.updateSearchRequestModel(maxSquare: square)
            })
            .store(in: &cancellables)

        model.filteredHousesCountPublisher
            .sinkWeakly(self, receiveValue: { (self, count) in
                self.filteredHousesCountSubject.value = count
            })
            .store(in: &cancellables)
    }

    func bindDataSource() {
        screenConfigurationSubject
            .receive(on: DispatchQueue.main)
            .sinkWeakly(self, receiveValue: { (self, value) in
                switch value {
                case 1:
                    self.propertyTypeCellModels = [
                        .init(propertyType: .apartment),
                        .init(propertyType: .house),
                    ]
                default:
                    self.propertyTypeCellModels = [
                        .init(propertyType: .apartment),
                        .init(propertyType: .house),
                        .init(propertyType: .land),
                    ]
                }
                self.updateDataSource()
            })
            .store(in: &cancellables)
    }

    func updateDataSource() {
        let segmentControlSection: SearchFiltersCollection = {
            SearchFiltersCollection(sections: .segmentControl, items: [.segmentControl])
        }()

        let model = OrtCellModel(ort: ortSubject.value)
        let ortSection: SearchFiltersCollection = {
            SearchFiltersCollection(sections: .ort, items: [.ort(model)])
        }()

        let distanceItems = distanceCellModels
            .map { SearchFiltersItem.distance($0) }
        let distanceSection = SearchFiltersCollection(
            sections: .distance,
            items: distanceItems
        )

        let priceSection: SearchFiltersCollection = {
            let model = PriceCellModel(
                minPrice: minPriceSubject.value,
                maxPrice: maxPriceSubject.value
            )
            return SearchFiltersCollection(sections: .price, items: [.price(model: model)])
        }()

        let yearSection: SearchFiltersCollection = {
            SearchFiltersCollection(
                sections: .year,
                items: [.year(.since1850)]
            )
        }()

        let squareSection: SearchFiltersCollection = {
            let model = SquareCellModel(minSquare: minSquareSubject.value, maxSquare: maxSquareSubject.value)
            return SearchFiltersCollection(
                sections: .square,
                items: [.square(model: model)]
            )
        }()

        let garageSection: SearchFiltersCollection = {
            SearchFiltersCollection(
                sections: .garage,
                items: [.garage(.garage)]
            )
        }()

        let numberOfRoomsItems = numberOfRoomsCellModels
            .map { SearchFiltersItem.roomsNumber($0) }
        let roomsNumberSection = SearchFiltersCollection(
            sections: .roomsNumber,
            items: numberOfRoomsItems
        )

        let typeItems = propertyTypeCellModels
            .map { SearchFiltersItem.type($0) }
        let typeSection = SearchFiltersCollection(
            sections: .type,
            items: typeItems
        )

        let backgroundSection: SearchFiltersCollection = {
            SearchFiltersCollection(
                sections: .backgroundItem,
                items: [.backgroundItem]
            )
        }()

        sections = [
            segmentControlSection,
            ortSection,
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
