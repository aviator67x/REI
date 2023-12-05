//
//  SortViewModel.swift
//  REI
//
//  Created by User on 03.08.2023.
//

import Combine
import Foundation

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
            sortingParameter: .addressUp,
            isHidden: false,
            isSelected: false,
            arrowImageName: "arrow.up"
        ),
        SortCellModel(
            name: "z - a",
            sortingParameter: .addressDown,
            isHidden: false,
            isSelected: false,
            arrowImageName: "arrow.down"
        ),
    ])
    private var tempAddressCellValue: [SortCellModel]?

    private lazy var dateCellSubject = CurrentValueSubject<[SortCellModel], Never>([
        SortCellModel(
            name: "newest first",
            sortingParameter: .dateNewFirst,
            isHidden: false,
            isSelected: false,
            arrowImageName: "arrow.down"
        ),
        SortCellModel(
            name: "oldest first",
            sortingParameter: .dateOldFirst,
            isHidden: false,
            isSelected: false,
            arrowImageName: "arrow.up"
        ),
    ])
    private var tempDateCellValue: [SortCellModel]?

    private lazy var priceCellSubject = CurrentValueSubject<[SortCellModel], Never>([
        SortCellModel(
            name: "min - max",
            sortingParameter: .priceUp,
            isHidden: false,
            isSelected: false,
            arrowImageName: "arrow.up"
        ),
        SortCellModel(
            name: "max - min",
            sortingParameter: .priceDown,
            isHidden: false,
            isSelected: false,
            arrowImageName: "arrow.down"
        ),
    ])
    private var tempPriceCellValue: [SortCellModel]?

    private var sortParameters: [String] = []

    private var searchModel: SearchModel

    // MARK: - Life cycle
    init(searchModel: SearchModel) {
        self.searchModel = searchModel
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
            for i in addressCellSubject.value.indices {
                if i != index {
                    addressCellSubject.value[i].isSelected = false
                }
            }
            addressCellSubject.value[index].isSelected.toggle()

            let parameter = addressCellSubject.value[index].sortingParameter.rawValue
            if let paramIndex = sortParameters.firstIndex(where: { $0 == parameter }) {
                sortParameters.remove(at: paramIndex)
            } else {
                let filtered = sortParameters
                    .filter {
                        $0 != SortingParameters.addressUp.rawValue && $0 != SortingParameters.addressDown.rawValue
                    }
                sortParameters = filtered
                sortParameters.append(parameter)
            }

        case let .price(priceCell):
            guard let index = priceCellSubject.value.firstIndex(where: { $0.id == priceCell.id }) else {
                return
            }
            for i in priceCellSubject.value.indices {
                if i != index {
                    priceCellSubject.value[i].isSelected = false
                }
            }
            priceCellSubject.value[index].isSelected.toggle()

            let parameter = priceCellSubject.value[index].sortingParameter.rawValue
            if let paramIndex = sortParameters.firstIndex(where: { $0 == parameter }) {
                sortParameters.remove(at: paramIndex)
            } else {
                let filtered = sortParameters
                    .filter { $0 != SortingParameters.priceUp.rawValue && $0 != SortingParameters.priceDown.rawValue }
                sortParameters = filtered
                sortParameters.append(parameter)
            }

        case let .date(dateCell):
            guard let index = dateCellSubject.value.firstIndex(where: { $0.id == dateCell.id }) else {
                return
            }
            for i in dateCellSubject.value.indices {
                if i != index {
                    dateCellSubject.value[i].isSelected = false
                }
            }
            dateCellSubject.value[index].isSelected.toggle()

            let parameter = dateCellSubject.value[index].sortingParameter.rawValue
            if let parameterIndex = sortParameters.firstIndex(where: { $0 == parameter }) {
                sortParameters.remove(at: parameterIndex)
            } else {
                let filtered = sortParameters
                    .filter {
                        $0 != SortingParameters.dateNewFirst.rawValue && $0 != SortingParameters.dateOldFirst.rawValue
                    }
                sortParameters = filtered
                sortParameters.append(parameter)
            }
        }
    }

    func getSortedHouses() {
        searchModel.updateSortParameters(parameters: sortParameters)
        searchModel.loadHousesAPI()
        transitionSubject.send(.popScreen)
    }

    func popScreen() {
        transitionSubject.send(.popScreen)
    }
}

// MARK: - private extension
private extension SortViewModel {
    func setupBinding() {
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

    func createDataSource() {
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
