//
//  MyHouseViewModel.swift
//  RomaMVVM
//
//  Created by User on 27.04.2023.
//

import Combine
import Foundation

final class MyHouseViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<MyHouseTransition, Never>()
    
    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private lazy var sectionsSubject = CurrentValueSubject<[MyHouseCollection], Never>([])

    private lazy var myHousesSubject = CurrentValueSubject<[HouseDomainModel], Never>([])

    private let userService: UserService
    private let housesService: HousesService

    init(userService: UserService, housesService: HousesService) {
        self.userService = userService
        self.housesService = housesService
        super.init()
    }
    
    override func onViewDidLoad() {
        setupBinding()
    }
    
    override func onViewWillAppear() {
        getUserAds()
    }
    
    private func setupBinding() {
        myHousesSubject
            .dropFirst()
            .sinkWeakly(
                self,
                receiveValue: { (self, value) in
                    self.setupDataSource()
                }
            )
            .store(in: &cancellables)
    }

    private func setupDataSource() {
        let items = myHousesSubject.value
            .map { PhotoCellModel(data: $0) }
            .map { MyHouseItem.photo($0) }
        let section = MyHouseCollection(section: .photo, items: items)
        sectionsSubject.value = [section]
    }
    
    private func getUserAds() {
        guard let userId = userService.user?.id else {
            return
        }
        isLoadingSubject.send(true)
        housesService.getUserAds(ownerId: userId)
            .receive(on: DispatchQueue.main)
            .sinkWeakly( self, receiveValue: { (sefl, houses) in
                self.isLoadingSubject.send(false)
                self.myHousesSubject.value = houses
            })
            .store(in: &cancellables)
    }

    func delete(_ item: MyHouseItem) {
        switch item {
        case .photo(let house):
            let id = house.id
            //            self.favouriteHousesSubject.value.removeAll(where: {$0.id == id})
            //            model.editFavouriteHouses(with: id)
        }
    }
    
    
    
    func moveToNextAd() {
        transitionSubject.send(.moveToAdAddress)
    }
}
