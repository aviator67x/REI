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
    @Published var isSelectHidden: Bool = false
    private var items: [FindItem] = []

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
                self.createDataSource(model: houses)
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
    func loadHouses() {
        model.loadHouses()
    }
    
    func setSelect(for offset: CGPoint) {
        isSelectHidden = offset.y > 100 ? true : false
    }

    func createDataSource(model: [HouseDomainModel]) {
        let items = model
            .map { PhotoCellModel(data: $0) }
            .map { FindItem.photo($0) }
        
        self.items.append(contentsOf: items)
        let section = FindCollection(section: .photo, items: self.items)
        sections = [section]
    }
}
