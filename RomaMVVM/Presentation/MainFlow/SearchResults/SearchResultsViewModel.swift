//
//  FindViewModel.swift
//  RomaMVVM
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

    private(set) lazy var resultViewModelPublisher = resultViewModelSubject.eraseToAnyPublisher()
    private lazy var resultViewModelSubject = CurrentValueSubject<ResultViewModel?, Never>(nil)

    private lazy var housesSubject = CurrentValueSubject<[HouseDomainModel], Never>([])

    init(model: SearchModel) {
        self.model = model
    }

    override func onViewDidLoad() {
        loadHouses()
        getFavouriteHouses()
        setupBinding()
    }

    private func setupBinding() {
        model.housesPublisher
            .sinkWeakly(self, receiveValue: { (self, houses) in
                self.housesSubject.value = houses
            })
            .store(in: &cancellables)

        housesSubject
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.createDataSource()
            })
            .store(in: &cancellables)

        sectionsSubject.combineLatest(model.searchParametersPublisher)
            .sink { [unowned self] sections, searchParams in
                var resultCount = 0
                if let section = sections.first(where: { $0.section == .photo }) {
                    resultCount = section.items.count
                } else if let section = sections.first(where: { $0.section == .list }) {
                    resultCount = section.items.count
                }
                self.resultViewModelSubject.value = ResultViewModel(
                    country: "Netherlands",
                    result: resultCount,
                    filters: searchParams.count
                )
            }
            .store(in: &cancellables)

        model.isLoadingPublisher
            .sinkWeakly(self, receiveValue: { (self, value) in
                self.isLoadingSubject.send(value)
            })
            .store(in: &cancellables)
    }
}

// MARK: - extension
extension SearchResultsViewModel {
    func editToFavourites(item: SearchResultsItem) {
        switch item {
        case let .photo(house):
            let id = house.id ?? ""
            var isFavourite = house.isFavourite
            isFavourite.toggle()
            model.editFavouriteHouses(with: id)
            let houseRequestModel = UpdateHouseFavouriteParameterRequestModel(isFavourite: isFavourite)
            model.updateHouses(with: houseRequestModel, houseId: id)

        case let .list(house):
            let id = house.id ?? ""
            var isFavourite = house.isFavourite
            isFavourite.toggle()
            model.editFavouriteHouses(with: id)
            let houseRequestModel = UpdateHouseFavouriteParameterRequestModel(isFavourite: isFavourite)
            model.updateHouses(with: houseRequestModel, houseId: id)

        case .main, .map:
            break
        }
    }

    func moveTo(_ screen: SelectViewAction) {
        switch screen {
        case .searchFilter:
            transitionSubject.send(.searchFilters(model))
        case .sort:
            transitionSubject.send(.sort)
        case .favourite:
            transitionSubject.send(.favourite)
        }
    }

    func setScreenState(_ state: SearchResultsScreenState) {
        screenState = state
        createDataSource()
    }

    func loadHouses() {
        model.loadHouses()
    }

    func getFavouriteHouses() {
        model.getFavouriteHouses()
    }

    func createDataSource() {
        switch screenState {
        case .photo:
            let items = housesSubject.value
                .map { PhotoCellModel(data: $0) }
                .map { SearchResultsItem.photo($0) }
            let section = SearchResultsCollection(section: .photo, items: items)
            sectionsSubject.value = [section]

        case .list:
            let mainViewItem = housesSubject.value
                .map { MainCellModel(data: $0) }
                .map { SearchResultsItem.main($0) }
                .randomElement()
            guard let item = mainViewItem else { return }
            let manViewSection = SearchResultsCollection(section: .main, items: [item])

            let items = housesSubject.value
                .map { ListCellModel(data: $0) }
                .map { SearchResultsItem.list($0) }
            let listSection = SearchResultsCollection(section: .list, items: items)
            sectionsSubject.value = [manViewSection, listSection]

        case .map:
            let mapItem = SearchResultsItem.map
            let mapSection = SearchResultsCollection(section: .map, items: [mapItem])
            sectionsSubject.value = [mapSection]
        }
    }
}
