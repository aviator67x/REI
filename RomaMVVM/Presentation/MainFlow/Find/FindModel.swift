//
//  FindModel.swift
//  RomaMVVM
//
//  Created by User on 14.04.2023.
//

import Combine
import Foundation

final class FindModel {
    private var cancellables = Set<AnyCancellable>()
    
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<FindTransition, Never>()
    
    private(set) lazy var isLoadingPublisher = isLoadingSubject.eraseToAnyPublisher()
    let isLoadingSubject = PassthroughSubject<Bool, Never>()

    let housesNetworkService: HousesNetworkService

    @Published var houses: [HouseDomainModel] = []

    @Published private var isPaginationInProgress = false
    private var hasMoreToLoad = true
    private var offset = 0
    private var pageSize = 1

    init(housesNetworkService: HousesNetworkService) {
        self.housesNetworkService = housesNetworkService
    }

    func loadHouses() {
        houses = []
        guard hasMoreToLoad,
              !isPaginationInProgress
        else {
            return
        }
        isPaginationInProgress = true
        housesNetworkService.getHouses(pageSize: pageSize, skip: offset)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")

                case let .failure(error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [unowned self] data in
                data.forEach { house in
                    let domainHouse = HouseDomainModel(model: house)
                    self.houses.append(domainHouse)
                    self.offset += data.count
                    self.hasMoreToLoad = data.count >= pageSize
                    self.isPaginationInProgress = false
                }
            })
            .store(in: &cancellables)
    }
}
