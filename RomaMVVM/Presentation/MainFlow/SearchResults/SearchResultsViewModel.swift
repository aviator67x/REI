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

    @Published var sections: [SearchResultsCollection] = []
    @Published var resultViewModel: ResultViewModel?
    
    private lazy var houses = CurrentValueSubject<[HouseDomainModel], Never>([])

    init(model: SearchModel) {
        self.model = model
    }

    override func onViewDidLoad() {
        model.loadHouses()
        setupBinding()
    }

    private func setupBinding() {
        model.$houses
            .sinkWeakly(self, receiveValue: { (self, houses) in
                self.houses.value = houses
            })
            .store(in: &cancellables)

        houses
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.createDataSource()
            })
            .store(in: &cancellables)

        $sections
            .sinkWeakly(
                self,
                receiveValue: { (self, sections) in
                    var resultCount = 0
                    if let section = sections.first(where: {$0.section == .photo}) {
                        resultCount =  section.items.count
                    } else if let section = sections.first(where: {$0.section == .list}) {
                        resultCount = section.items.count
                    }
                    self.resultViewModel = ResultViewModel(country: "Netherlands", result: resultCount, filters: 9)
                }
            )
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
            sections = [section]
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
            sections = [manViewSection, listSection]
        case .map:
            let mapItem = SearchResultsItem.map
            let mapSection = SearchResultsCollection(section: .map, items: [mapItem])
            sections = [mapSection]
        }
    }
}
