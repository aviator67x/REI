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

    private lazy var houses = CurrentValueSubject<[HouseDomainModel], Never>([])

    init(model: SearchModel) {
        self.model = model
    }

    override func onViewDidLoad() {
        model.loadHouses()
        setupBinding()
    }

    private func setupBinding() {
        model.housesPublisher
            .sinkWeakly(self, receiveValue: { (self, houses) in
                self.houses.value = houses
            })
            .store(in: &cancellables)

        houses
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
    func addToFavourities(item: SearchResultsItem) {
        switch item {
        case .photo(let house):
            let id = house.id ?? ""
            self.model.addToFavouritiesHouse(with: id) 
        case .main(_):
            break
        case .list(_):
            break
        case .map:
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

    func createDataSource() {
        switch screenState {
        case .photo:
            let items = houses.value
                .map { PhotoCellModel(data: $0) }
                .map { SearchResultsItem.photo($0) }
            let section = SearchResultsCollection(section: .photo, items: items)
            sectionsSubject.value = [section]
        case .list:
            let mainViewItem = houses.value
                .map { MainCellModel(data: $0) }
                .map { SearchResultsItem.main($0) }
                .randomElement()
            guard let item = mainViewItem else { return }
            let manViewSection = SearchResultsCollection(section: .main, items: [item])

            let items = houses.value
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
