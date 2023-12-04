//
//  FindViewModel.swift
//  REI
//
//  Created by User on 05.04.2023.
//

import Combine
import Foundation

final class SearchResultsViewModel: BaseViewModel {
    private var screenState = SearchResultsScreenState.photo
    private let model: SearchModel

    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<FindTransition, Never>()

    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private lazy var sectionsSubject = CurrentValueSubject<[SearchResultsCollection], Never>([])
    
    private(set) lazy var mapViewPublisher = mapViewSubject.eraseToAnyPublisher()
    private lazy var mapViewSubject = CurrentValueSubject<MapCellModel?, Never>(nil)

    private(set) lazy var resultViewModelPublisher = resultViewModelSubject.eraseToAnyPublisher()
    private lazy var resultViewModelSubject = CurrentValueSubject<ResultViewModel?, Never>(nil)

    private lazy var housesSubject = CurrentValueSubject<[HouseDomainModel], Never>([])

    private lazy var favouriteIdsSubject = CurrentValueSubject<[String], Never>([])

    // MARK: - Life cycle
    init(model: SearchModel) {
        self.model = model
    }

    override func onViewDidLoad() {
        model.loadHouses()
//        model.loadMockHouses()
        model.getHousesCount()
        setupBinding()
    }

    override func onViewWillAppear() {
        model.getFavouriteHouses()
    }


// MARK: - Private methods
   private func setupBinding() {
        model.favouriteHousesIdPublisher
            .receive(on: DispatchQueue.main)
            .sinkWeakly(self, receiveValue: { (self, favouriteIds) in
                self.favouriteIdsSubject.value = favouriteIds
                self.createDataSource()
            })
            .store(in: &cancellables)

        model.housesPublisher
            .receive(on: DispatchQueue.main)
            .sinkWeakly(self, receiveValue: { (self, houses) in
                self.housesSubject.value = houses
            })
            .store(in: &cancellables)

        housesSubject
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.createDataSource()
            })
            .store(in: &cancellables)
       
//       housesSubject.zip(model.searchParametersPublisher,
//                          model.housesCountPublisher)
        housesSubject.combineLatest(
            model.searchParametersPublisher,
            model.housesCountPublisher
        )
        .sink { [unowned self] houses, searchParams, housesCount in
            self.resultViewModelSubject.value = ResultViewModel(
                country: "Netherlands",
                result: model.isFilterActive ? houses.count : housesCount,
                filters: searchParams.count
            )
        }
        .store(in: &cancellables)
       
       housesSubject
           .sinkWeakly(self) { (self, houses) in
               print("🔱 receeved value to housesSubject")
           }
           .store(in: &cancellables)
       
        model.isLoadingPublisher
            .sinkWeakly(self, receiveValue: { (self, value) in
                self.isLoadingSubject.send(value)
            })
            .store(in: &cancellables)
    }

    private func createDataSource() {
        switch screenState {
        case .photo:
            let items = housesSubject.value
                .map { if favouriteIdsSubject.value.contains($0.id) {
                    return PhotoCellModel(data: $0, isFavourite: true)
                } else {
                    return PhotoCellModel(data: $0, isFavourite: false)
                }
                }
                .map { SearchResultsItem.photo($0) }
            let section = SearchResultsCollection(section: .photo, items: items)
            sectionsSubject.value = [section]

        case .list:
            let items = housesSubject.value
                .map { if favouriteIdsSubject.value.contains($0.id) {
                    return ListCellModel(data: $0, isFavourite: true)
                } else {
                    return ListCellModel(data: $0, isFavourite: false)
                }
                }
                .map { SearchResultsItem.list($0) }
            let listSection = SearchResultsCollection(section: .list, items: items)
            
            let mainViewItem = housesSubject.value
                .map { MainCellModel(data: $0) }
                .map { SearchResultsItem.main($0) }
                .randomElement()
           if let item = mainViewItem  {
              let mainViewSection = SearchResultsCollection(section: .main, items: [item])
               sectionsSubject.value = [mainViewSection, listSection]
           } else {
               sectionsSubject.value = [listSection]
           }

        case .map:
            break
        }
    }
}

// MARK: - Internal extension
extension SearchResultsViewModel {
    func loadHouses() {
        model.loadHousesAPI()
    }
    
    func getAvailableHouses(in poligon: String) {
        model.getAvailableHouses(in: poligon)
    }

    func editFavourites(item: SearchResultsItem) {
        switch item {
        case let .photo(house):
            model.editFavouriteHouses(with: house.id)

        case let .list(house):
            model.editFavouriteHouses(with: house.id)

        case .main:
            break
        }
    }

    func moveTo(_ screen: SelectViewAction) {
        switch screen {
        case .searchFilter:
            transitionSubject.send(.searchFilters(model))
        case .sort:
            transitionSubject.send(.sort)
        case .lastSearch:
            // get searchParameters from UserDefaults
            guard let parametersData = UserDefaults.standard.value(forKey: "searchParameters") as? Data,
               let parameters = try? JSONDecoder().decode([SearchParam].self, from: parametersData) else {
                return
            }
            // get searchParameters from Documents
//            FileService().readDataFromDocument(filename: "SearchParameters", decodingType: [SearchParam])
            model.executeSearch(with: parameters)
        }
    }

    func showSelectedItem(_ item: SearchResultsItem) {
        switch item {
        case let .photo(model):
            let id = model.id
            guard let house = housesSubject.value.first(where: { $0.id == id }) else {
                return
            }
            transitionSubject.send(.selectedHouse(house))

        case let .list(model):
            let id = model.id
            guard let house = housesSubject.value.first(where: { $0.id == id }) else {
                return
            }
            transitionSubject.send(.selectedHouse(house))

        case let .main(model):
            let id = model.id
            guard let house = housesSubject.value.first(where: { $0.id == id }) else {
                return
            }
            transitionSubject.send(.selectedHouse(house))
        }
    }

    func setScreenState(_ state: SearchResultsScreenState) {
        screenState = state
        switch screenState {
        case .photo, .list:
            createDataSource()
        case .map:
            let mapViewModel = MapCellModel(data: housesSubject.value)
            mapViewSubject.value = mapViewModel
        }
    }
}
