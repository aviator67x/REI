//
//  FindViewModel.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import Combine
import Foundation

final class FindViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<FindTransition, Never>()

    @Published var sections: [FindCollection] = []

    @Published private var items = [FindItem]()
    @Published private(set) var itemsToReload: [FindSection: [FindItem]] = [:]
    @Published private var isPaginationInProgress = false
    private var hasMoreToLoad = true
    private var offset = 0
    private var pageSize = 1

    let houseNetworkService: HousesNetworkService

    init(houseNetworkService: HousesNetworkService) {
        self.houseNetworkService = houseNetworkService
        super.init()
    }

    override func onViewDidLoad() {
        updateDataSource()
    }

    func updateDataSource() {
        houseNetworkService.getHouses(pageSize: pageSize, skip: offset)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished")
                    self.offset = self.pageSize
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { value in
                let items = value
                    .map { PhotoCellModel(data: $0) }
                    .map { FindItem.photo($0) }

                self.items.append(contentsOf: items)
                let section = FindCollection(section: .photo, items: self.items)
                self.sections.append(section)
            })
            .store(in: &cancellables)
    }

    func addItemsToSection() {
        guard hasMoreToLoad,
            !isPaginationInProgress else {
            return
        }
        isPaginationInProgress = true
        houseNetworkService.getHouses(pageSize: pageSize, skip: offset)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.addItems()
                case let .failure(error):
                    print(error.errorDescription ?? "")
                }
            }, receiveValue: { [unowned self] value in
                self.offset += value.count
                self.hasMoreToLoad = value.count >= pageSize 
                let items = value
                    .map { PhotoCellModel(data: $0) }
                    .map { FindItem.photo($0) }

                self.items = []
                self.items = items
                isPaginationInProgress = false
            })
            .store(in: &cancellables)
    }

    private func addItems() {
        $items.combineLatest($isPaginationInProgress)
            .sink { [unowned self] items in
                if items.1 {
                    itemsToReload = [.photo: items.0]
                }
            }
            .store(in: &cancellables)
    }
}
