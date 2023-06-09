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

    private lazy var ortSubject = CurrentValueSubject<String?, Never>(nil)
    private lazy var minPriceSubject = CurrentValueSubject<String?, Never>(nil)
    private lazy var maxPriceSubject = CurrentValueSubject<String?, Never>(nil)
    private lazy var minSquareSubject = CurrentValueSubject<String?, Never>(nil)
    private lazy var maxSquareSubject = CurrentValueSubject<String?, Never>(nil)

    private let model: SearchModel
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

    private var propertyTypeCellModels: [PropertyTypeCellModel] = [
        .init(propertyType: .apartment),
        .init(propertyType: .house),
        .init(propertyType: .land),
    ]

    private var numberOfRoomsCellModels: [NumberOfRoomsCellModel] = [
        .init(numberOfRooms: .one),
        .init(numberOfRooms: .two),
        .init(numberOfRooms: .three),
        .init(numberOfRooms: .four),
        .init(numberOfRooms: .five),
    ]
    
    private(set) lazy var searchRequestModelPublisher = searchRequestModelSubject.eraseToAnyPublisher()
    private lazy var searchRequestModelSubject = CurrentValueSubject<SearchRequestModel, Never>(.init())

    init(model: SearchModel) {
        self.model = model
        super.init()
    }

    override func onViewDidLoad() {
        setupBinding()
        updateDataSource()
        checkSearchRequestModel()
    }

    func checkSearchRequestModel() {
        switch searchRequestModelSubject.value.distance {
        case .none:
          return
        case let .some(distance):
            guard let index = distanceCellModels.firstIndex(where: { $0.distance == distance }) else {
                return
            }
            distanceCellModels[index].isSelected = true
            updateDataSource()
        }
        switch searchRequestModelSubject.value.propertyType {
        case .none:
            return
        case let .some(type):
            guard let index = propertyTypeCellModels.firstIndex(where: { $0.propertyType == type }) else {
                return
            }
            propertyTypeCellModels[index].isSelected = true
            updateDataSource()
        }
        switch searchRequestModelSubject.value.roomsNumber {
        case .none:
            updateDataSource()
        case let .some(number):
            guard let index = numberOfRoomsCellModels.firstIndex(where: { $0.numberOfRooms == number }) else {
                return
            }
            numberOfRoomsCellModels[index].isSelected = true
            updateDataSource()
            
        }
    }
}

// MARK: - extension
extension SearchFiltersViewModel {
    func cleanFilters() {
        model.cleanSearchRequestModel()
    }

    func configureScreen(for index: Int) {
        screenConfiguration = index
    }

    func updateDistance(_ distance: DistanceCellModel) {
        model.updateSearchRequestModel(distance: distance.distance)
        for (index, _) in distanceCellModels.enumerated() {
            distanceCellModels[index].isSelected = false
        }
        guard let selectedItemIndex = distanceCellModels.firstIndex(of: distance) else {
            return
        }
        distanceCellModels[selectedItemIndex].isSelected.toggle()
        updateDataSource()
    }

    func updateType(_ type: PropertyTypeCellModel) {
        model.updateSearchRequestModel(propertyType: type.propertyType)
        for (index, _) in propertyTypeCellModels.enumerated() {
            propertyTypeCellModels[index].isSelected = false
        }
        guard let selectedItemIndex = propertyTypeCellModels.firstIndex(of: type) else {
            return
        }
        propertyTypeCellModels[selectedItemIndex].isSelected.toggle()
        updateDataSource()
    }

    func updateNumberOfRooms(_ number: NumberOfRoomsCellModel) {
        model.updateSearchRequestModel(roomsNumber: number.numberOfRooms)
        for (index, _) in numberOfRoomsCellModels.enumerated() {
            numberOfRoomsCellModels[index].isSelected = false
        }
        guard let selectedItemIndex = numberOfRoomsCellModels.firstIndex(of: number) else {
            return
        }
        numberOfRoomsCellModels[selectedItemIndex].isSelected.toggle()
        updateDataSource()
    }

    func executeSearch() {
        model.executeSearch()
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
        model.searchRequestModelPublisher
            .receive(on: DispatchQueue.main)
            .sinkWeakly(self, receiveValue: { (self, requestModel) in
                self.searchRequestModelSubject.value = requestModel
            })
            .store(in: &cancellables)
        
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

    func updateDataSource() {
        let segmentControlSection: SearchFiltersCollection = {
            SearchFiltersCollection(sections: .segmentControl, items: [.segmentControl])
        }()
        
        let model = OrtCellModel(ort: ortSubject)
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
            SearchFiltersCollection(sections: .backgroundItem, items: [.backgroundItem])
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
