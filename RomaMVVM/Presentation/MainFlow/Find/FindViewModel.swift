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

    let houseNetworkService: HousesNetworkService

    init(houseNetworkService: HousesNetworkService) {
        self.houseNetworkService = houseNetworkService
        super.init()
    }

    override func onViewDidLoad() {
        updateDataSource()
    }

    func updateDataSource() {
        guard let imageURL = URL(string: "https://closedoor.backendless.app/api/files/Houses/IMG_0407-min.jpg"),
              let imageURL1 = URL(string: "https://closedoor.backendless.app/api/files/Houses/IMG_0408-min.jpg"),
              let imageURL2 = URL(string: "https://closedoor.backendless.app/api/files/Houses/IMG_0414-min.jpg")
        else {
            return
        }
        let model = PhotoCellModel(
            image: imageURL,
            street: "Dorpstraat, 41",
            ort: "1721 BB Broek-op-Langedejk",
            livingArea: 65,
            square: 120,
            numberOfRooms: "5",
            price: 318_000
        )
        let model1 = PhotoCellModel(
            image: imageURL1,
            street: "Burgerstraat, 41",
            ort: "2121 BB Sint-Pankras",
            livingArea: 105,
            square: 180,
            numberOfRooms: "6",
            price: 480_000
        )
        let model2 = PhotoCellModel(
            image: imageURL2,
            street: "Lindenstraat, 41",
            ort: "5612 AB Alkmaar",
            livingArea: 80,
            square: 95,
            numberOfRooms: "3",
            price: 269_000
        )
        var models = [model1, model2, model]
        houseNetworkService.getHouses()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("FINISHED")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { value in
                models.removeAll()
                value.forEach { house in
                    let model = PhotoCellModel(image: house.images[0], street: house.street, ort: house.ort, livingArea: 50, square: house.square, numberOfRooms: String(house.rooomsNumber), price: 800000)
                    models.append(model)
                }
                var items = [FindItem]()
                for model in models {
                    let item: FindItem = .photo(model)
                    items.append(item)
                }
                let section = FindCollection(section: .photlo, items: items)
                self.sections.append(section)
            })
            .store(in: &cancellables)
    }
}
