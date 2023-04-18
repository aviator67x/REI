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

    @Published var sections: [FindCollection] = []
    @Published private(set) var itemsToReload: [FindSection: [FindItem]] = [:]

    init(model: FindModel) {
        self.model = model
    }

    override func onViewDidLoad() {
        createDataSource(model: [])
        model.loadHouses()
        setupBinding()
    }

    private func setupBinding() {
        model.$houses
            .sinkWeakly(self, receiveValue: { (self, houses) in
                print("Print from ViewModel \(houses.count)")
                self.addItemsToSection(model: houses)
            })
            .store(in: &cancellables)
    }
}

// MARK: - extension
extension FindViewModel {
    func loadHouses() {
        model.loadHouses()
    }

    func createDataSource(model: [HouseDomainModel]) {
        let section = FindCollection(section: .photo, items: [])
        sections.append(section)
    }

    func addItemsToSection(model: [HouseDomainModel]) {
        let items = model
            .map { PhotoCellModel(data: $0) }
            .map { FindItem.photo($0) }
        itemsToReload = [.photo: items]
    }
}
