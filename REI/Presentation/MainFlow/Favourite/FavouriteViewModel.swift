//
//  FavouriteViewModel.swift
//  RomaMVVM
//
//  Created by User on 27.04.2023.
//

import Combine
import Foundation

final class FavouriteViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<FavouriteTransition, Never>()

    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private lazy var sectionsSubject = CurrentValueSubject<[FavouriteCollection], Never>([])

    private(set) lazy var favouriteHousesPublisher = favouriteHousesSubject.eraseToAnyPublisher()
    private lazy var favouriteHousesSubject = CurrentValueSubject<[HouseDomainModel], Never>([])

    private let model: SearchModel

    init(model: SearchModel) {
        self.model = model
        super.init()
    }

    override func onViewDidLoad() {
        setupBinding()
    }
    
    override func onViewWillAppear() {
        guard let favouriteHouses =
                model.favouriteHouses() else {
            return
        }
        favouriteHousesSubject.value = favouriteHouses
    }

    private func setupBinding() {
        favouriteHousesSubject
            .sinkWeakly(
                self,
                receiveValue: { (self, _) in
                    self.setupDataSource()
                }
            )
            .store(in: &cancellables)
    }

    private func setupDataSource() {
        let items = favouriteHousesSubject.value
            .map { PhotoCellModel(data: $0) }
            .map { FavouriteItem.photo($0) }
        let section = FavouriteCollection(section: .photo, items: items)
        sectionsSubject.value = [section]
    }

    func deleteItem(_ item: FavouriteItem) {
        switch item {
        case .photo(let house):
            let id = house.id 
            self.favouriteHousesSubject.value.removeAll(where: {$0.id == id})
            model.editFavouriteHouses(with: id)
        }
    }
}
