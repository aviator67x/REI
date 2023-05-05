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
    private lazy var sectionsSubject = CurrentValueSubject<[SearchResultsCollection], Never>([])

    private lazy var favouriteHouses = CurrentValueSubject<[HouseDomainModel], Never>([])
    
    private let userService: UserService

    init(userService: UserService) {
        self.userService = userService
        super.init()
    }

    override func onViewDidLoad() {
        setupBinding()
//        favouriteHouses.value = userService.user.favouriteHouses
        favouriteHouses.value = [HouseDomainModel(id: "10", distance: 5, constructionYear: 2010, garage: "garage", images: [URL(string: "https://closedoor.backendless.app/api/files/Houses/IMG_0409-min.jpg")!], ort: "Munich", livingArea: 105, square: 130, street: "Brandenburger 14", propertyType: "House", roomsNumber: 5, price: 350000)]
    }

    private func setupBinding() {
        favouriteHouses
            .sinkWeakly(
                self,
                receiveValue: { (self, houses) in
                    self.setupDataSource()
                }
            )
            .store(in: &cancellables)
    }
    
    private func setupDataSource() {
        let items = favouriteHouses.value
            .map { PhotoCellModel(data: $0) }
            .map { SearchResultsItem.photo($0)}
        let section = SearchResultsCollection(section: .photo, items: items)
        sectionsSubject.value = [section]
    }
}