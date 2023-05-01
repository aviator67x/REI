//
//  FindViewModel.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import Combine
import Foundation

final class FindViewModel: BaseViewModel {
    private var screenState = FindScreenState.photo
    
    private let model: FindModel

    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<FindTransition, Never>()

    @Published var sections: [FindCollection] = []
    private lazy var houses = CurrentValueSubject<[HouseDomainModel], Never>([])
  
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
                self.houses.value = houses
            })
            .store(in: &cancellables)
        
        houses
            .sinkWeakly(self, receiveValue: { (self, houses) in
                self.createDataSource()
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
            transitionSubject.send(.search)
        case .sort:
            transitionSubject.send(.sort)
        case .favourite:
            transitionSubject.send(.favourite)
        }
    }

    func setScreenState(_ state: FindScreenState) {
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
                .map { FindItem.photo($0) }
            let section = FindCollection(section: .photo, items: items)
            sections = [section]
        case .list:
            let mainViewItem = houses.value
                .map { MainCellModel(data: $0) }
                .map { FindItem.main($0) }
                .randomElement()
            guard let item = mainViewItem else { return }
            let manViewSection = FindCollection(section: .main, items: [item])

            let items = houses.value
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
