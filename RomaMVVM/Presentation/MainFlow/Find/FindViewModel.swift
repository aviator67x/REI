//
//  FindViewModel.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import Combine
import Foundation

final class FindViewModel: BaseViewModel {
    private let model: FindModel

    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<FindTransition, Never>()

    @Published var sections: [FindCollection] = []

    var screenState = FindScreenState.photo

    init(model: FindModel) {
        self.model = model
    }

    override func onViewDidLoad() {
        model.loadHouses()
        setupBinding()
    }

    private func setupBinding() {
        model.$houses
            .sinkWeakly(self, receiveValue: { (self, houses) in
                self.createDataSource(model: houses, screenState: self.screenState)
            })
            .store(in: &cancellables)

        model.isLoadingPublisher
            .sinkWeakly(self, receiveValue: { (self, value) in
                self.isLoadingSubject.send(value)
            })
            .store(in: &cancellables)
    }
}

// MARK: - extension
extension FindViewModel {
    func moveTo(_ screen: SelectViewAction) {
        switch screen {
        case .find:
            self.transitionSubject.send(.search)
        case .sort:
            self.transitionSubject.send(.sort)
        case .favourite:
            self.transitionSubject.send(.favourite)
        }
    }
    
    func setScreenState(_ state: FindScreenState) {
        screenState = state
        createDataSource(model: model.houses, screenState: state)
    }

    func loadHouses() {
        model.loadHouses()
    }

    func createDataSource(model: [HouseDomainModel], screenState: FindScreenState) {
        switch screenState {
        case .photo:
            let items = model
                .map { PhotoCellModel(data: $0) }
                .map { FindItem.photo($0) }
            let section = FindCollection(section: .photo, items: items)
            sections = [section]
        case .list:
            let mainViewItem = model
                .map { MainCellModel(data: $0) }
                .map { FindItem.main($0) }
                .randomElement()
            guard let item = mainViewItem else { return }
            let manViewSection = FindCollection(section: .main, items: [item])

            let items = model
                .map { ListCellModel(data: $0) }
                .map { FindItem.list($0) }
            let listSection = FindCollection(section: .list, items: items)
            sections = [manViewSection, listSection]
        case .map:
            let mapItem = FindItem.map
            let mapSection = FindCollection(section: .map, items: [mapItem])
            sections = [mapSection]
        }
    }
}
