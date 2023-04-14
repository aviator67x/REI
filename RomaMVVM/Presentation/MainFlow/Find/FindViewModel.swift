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
    @Published private var isReloadItems = true
    @Published private(set) var itemsToReload = [FindItem]()
    private var skipCounter = 0
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
        houseNetworkService.getHouses(pageSize: pageSize, skip: 0)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished")
                    self.skipCounter = self.pageSize
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { value in
                var models: [PhotoCellModel] = []
                value.forEach { house in
                    let model = PhotoCellModel(
                        image: house.images[0],
                        street: house.street,
                        ort: house.ort,
                        livingArea: 50,
                        square: house.square,
                        numberOfRooms: String(house.rooomsNumber),
                        price: 800_000
                    )
                    models.append(model)
                }

                for model in models {
                    let item: FindItem = .photo(model)
                    self.items.append(item)
                }
                let section = FindCollection(section: .photo, items: self.items)
                self.sections.append(section)
            })
            .store(in: &cancellables)
    }

    func addItemsToSection() {
        if isReloadItems {
            isReloadItems = false
            houseNetworkService.getHouses(pageSize: pageSize, skip: skipCounter)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Finished")
                        self.skipCounter += self.pageSize
                        self.addItems()
                    case let .failure(error):
                        print(error.errorDescription ?? "")
                    }
                }, receiveValue: { [unowned self] value in
                    var models: [PhotoCellModel] = []
                    value.forEach { house in
                        let model = PhotoCellModel(
                            image: house.images[0],
                            street: house.street,
                            ort: house.ort,
                            livingArea: 50,
                            square: house.square,
                            numberOfRooms: String(house.rooomsNumber),
                            price: 800_000
                        )
                        models.append(model)
                    }
                    self.items = []
                    
                    for model in models {
                        let item: FindItem = .photo(model)
                        self.items.append(item)
                        print(items.count)
                    }
                })
                .store(in: &cancellables)
        }
    }

    private func addItems() {
        $items.combineLatest($isReloadItems)
            .map { $0 }
            .sink { [unowned self] items in
                if items.1 {
                    itemsToReload = items.0
                }
            }
            .store(in: &cancellables)
        isReloadItems = true
    }
}
