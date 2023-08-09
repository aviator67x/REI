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
                sectionType: .address,
                isCheckmarkHidden: false
            ),
            TitleCellModel(
                sectionType: .price,
                isCheckmarkHidden: false
            ),
            TitleCellModel(
                sectionType: .date,
                isCheckmarkHidden: false
            ),
        ]
    )

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
    private var tempAddressCellValue: [SortCellModel]?

    private lazy var dateCellSubject = CurrentValueSubject<[SortCellModel], Never>([
        SortCellModel(
            name: "newest first",
            isHidden: false,
            isSelected: false,
            arrowImageName: "arrow.down"
        ),
        SortCellModel(
            name: "oldest first",
            isHidden: false,
            isSelected: false,
            arrowImageName: "arrow.up"
        ),
    ])
    private var tempDateCellValue: [SortCellModel]?

    private lazy var priceCellSubject = CurrentValueSubject<[SortCellModel], Never>([
        SortCellModel(
            name: "min - max",
            isHidden: false,
            isSelected: false,
            arrowImageName: "arrow.up"
        ),
        SortCellModel(
            name: "max - min",
            isHidden: false,
            isSelected: false,
            arrowImageName: "arrow.down"
        ),
    ])
    private var tempPriceCellValue: [SortCellModel]?

    override init() {
        super.init()
    }

    override func onViewDidLoad() {
        setupBinding()
    }

    func updateCellModel(_ cell: SortItem) {
        switch cell {
        case let .title(titleCell):
            guard let index = titleCellSubject.value.firstIndex(where: { $0.id == titleCell.id }) else {
                return
            }
            titleCellSubject.value[index].isCheckmarkHidden.toggle()
            switch titleCell.sectionType {
            case .address:
                if !addressCellSubject.value.isEmpty {
                    tempAddressCellValue = addressCellSubject.value
                    addressCellSubject.value.removeAll()
                } else {
                    guard let tempAddressCellSubj = tempAddressCellValue else {
                        return
                    }
                    addressCellSubject.value = tempAddressCellSubj
                }

            case .price:
                if !priceCellSubject.value.isEmpty {
                    tempPriceCellValue = priceCellSubject.value
                    priceCellSubject.value.removeAll()
                } else {
                    guard let tempPriceCellValue = tempPriceCellValue else {
                        return
                    }
                    priceCellSubject.value = tempPriceCellValue
                }
            case .date:
                if !dateCellSubject.value.isEmpty {
                    tempDateCellValue = dateCellSubject.value
                    dateCellSubject.value.removeAll()
                } else {
                    guard let tempDateCellValue = tempDateCellValue else {
                        return
                    }
                    dateCellSubject.value = tempDateCellValue
                }
            }
        case let .address(addressCell):
            guard let index = addressCellSubject.value.firstIndex(where: { $0.id == addressCell.id }) else {
                return
            }
            addressCellSubject.value[index].isSelected.toggle()

        case let .price(priceCell):
            guard let index = priceCellSubject.value.firstIndex(where: { $0.id == priceCell.id }) else {
                return
            }
            priceCellSubject.value[index].isSelected.toggle()

        case let .date(dateCell):
            guard let index = dateCellSubject.value.firstIndex(where: { $0.id == dateCell.id }) else {
                return
            }
            dateCellSubject.value[index].isSelected.toggle()
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
        
        dateCellSubject
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.createDataSource()
            })
            .store(in: &cancellables)
    }

    private func createDataSource() {
        sectionsSubject.value = titleCellSubject.value
            .map { value -> SortTable in
                let sectionTitleItem = SortItem.title(model: value)
                var sectionItems: [SortItem]
                switch value.sectionType {
                case .address:
                    sectionItems = addressCellSubject.value
                        .map { SortItem.address(model: $0) }
                case .price:
                    sectionItems = priceCellSubject.value
                        .map { SortItem.price(model: $0) }
                case .date:
                    sectionItems = dateCellSubject.value
                        .map { SortItem.date(model: $0) }
                }
                sectionItems.insert(sectionTitleItem, at: 0)
                return SortTable(section: value.sectionType, items: sectionItems)
            }
    }
}
