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
//    @Published private(set) var itemsToReload: [FindSection: [FindItem]] = [:]
    @Published var isSelectViewHidden: Bool = false
    private var screenState: FindScreenState = .photo
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
    
    func setScreenState(for index: Int) {
        switch index {
        case 1:
            screenState = .photo
        case 2:
            screenState = .list
        case 3:
            screenState = .map
        default:
            break
        }
    }
    
    func setSelectViewState(for offset: CGPoint) {
        isSelectViewHidden = offset.y > 100 ? true : false
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
