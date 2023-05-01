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

    private(set) lazy var isLoadingPublisher = isLoadingSubject.eraseToAnyPublisher()
    let isLoadingSubject = PassthroughSubject<Bool, Never>()

    let housesService: HousesService

    @Published var houses: [HouseDomainModel] = []

    @Published private var isPaginationInProgress = false
    private var hasMoreToLoad = true
    private var offset = 0
    private var pageSize = 2

    init(housesService: HousesService) {
        self.housesService = housesService
    }

    func loadHouses() {
        guard hasMoreToLoad,
              !isPaginationInProgress
        else {
            return
        }
        isPaginationInProgress = true
        isLoadingSubject.send(true)
        housesService.getHouses(pageSize: pageSize, offset: offset)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoadingSubject.send(false)
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [unowned self] data in
                NetworkLogger.log(data: data)
                self.houses.append(contentsOf: data)
                self.offset += data.count
                self.hasMoreToLoad = offset >= pageSize
                self.isPaginationInProgress = false
            })
            .store(in: &cancellables)
    }
}
