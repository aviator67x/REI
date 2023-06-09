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
    
    private let model: AdCreatingModel

    init(model: AdCreatingModel) {
        self.model = model
        super.init()
    }
    
    override func onViewDidLoad() {
        setupBinding()
    }
    
    override func onViewWillAppear() {
        getUserAds()
    }
    
    private func setupBinding() {
        model.myHousePublisher
            .sinkWeakly(self, receiveValue: { (self, houses) in
                self.myHousesSubject.value = houses
                guard let house = houses.first else {
                    return
                }
                self.transitionSubject.send(.detail(house))
            })
            .store(in: &cancellables)
        
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
    
    func moveToNextAd() {
        transitionSubject.send(.moveToAdAddress(model: model))
    }
    
    func getUserAds() {
        model.getUserAds()
    }
    
    func delete(_ item: MyHouseItem)  {
        model.delete(item)
    }
}
