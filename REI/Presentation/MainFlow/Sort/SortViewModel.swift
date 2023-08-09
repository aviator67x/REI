//
//  SortViewModel.swift
//  REI
//
//  Created by User on 03.08.2023.
//

import Combine

final class SortViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SortTransition, Never>()

    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private lazy var sectionsSubject = CurrentValueSubject<[SortTable], Never>([])

    private lazy var titleCellSubject = CurrentValueSubject<
        [TitleCellModel], Never
    >(
        [
        TitleCellModel(
            sectionType: .address, title: "Address",
            isCheckmarkHidden: false
        ),
        TitleCellModel(
            sectionType: .price, title: "Price",
            isCheckmarkHidden: false
        ),
    ])

    private lazy var addressCellSubject = CurrentValueSubject<[SortCellModel], Never>([
        SortCellModel(
            name: "a - z",
            isHidden: false,
            isSelected: false,
            arrowImageName: "arrow.up"
        ),
        SortCellModel(
            name: "z - a",
            isHidden: false,
            isSelected: false,
            arrowImageName: "arrow.down"
        ),
    ])

    private lazy var priceCellSubject = CurrentValueSubject<[SortCellModel], Never>([
        SortCellModel(
            name: "min - max",
            isHidden: false,
            isSelected: false,
            arrowImageName: "arrow.up"),
        SortCellModel(
            name: "max - min",
            isHidden: false,
            isSelected: false,
            arrowImageName: "arrow.down"
        ),
    ])

    override init() {
        super.init()
    }

    override func onViewDidLoad() {
        setupBinding()
    }

    func updateCellModel(_ cell: SortItem) {
        switch cell {
        case let .address(addressCell):
            guard let index = addressCellSubject.value.firstIndex(where: { $0.id == addressCell.id }) else {
                return
            }
            addressCellSubject.value[index].isSelected.toggle()
        case let .title(titleCell):
            guard let index = titleCellSubject.value.firstIndex(where: { $0.id == titleCell.id }) else {
                return
            }
            titleCellSubject.value[index].isCheckmarkHidden.toggle()
        case let .price(priceCell):
            guard let index = priceCellSubject.value.firstIndex(where: { $0.id == priceCell.id }) else {
                return
            }
            priceCellSubject.value[index].isSelected.toggle()
        }
    }

    private func setupBinding() {
        titleCellSubject
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.createDataSource()
            })
            .store(in: &cancellables)
        
        addressCellSubject
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.createDataSource()
            })
            .store(in: &cancellables)

        priceCellSubject
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.createDataSource()
            })
            .store(in: &cancellables)
    }

    private func createDataSource() {
        let addressTitleCellModel = titleCellSubject.value[0]
        let titleItem = SortItem
            .title(model: addressTitleCellModel)
        var addressSectionItems = [titleItem]
        var addressItems = addressCellSubject.value
            .map { SortItem.address(model: $0) }
        addressSectionItems.append(contentsOf: addressItems)
        let addressSection = SortTable(section: .address, items: addressSectionItems)
        sectionsSubject.value = [addressSection]

        let priceTitleCellModel = titleCellSubject.value[1]
        let priceTitleItem = SortItem
            .title(model: priceTitleCellModel)
        var priceSectionItems = [priceTitleItem]
        var priceItems = priceCellSubject.value
            .map { SortItem.price(model: $0)}
        priceSectionItems.append(contentsOf: priceItems)
        let priceSection = SortTable(section: .price, items: priceSectionItems)
        sectionsSubject.value.append(priceSection)
    }
}
