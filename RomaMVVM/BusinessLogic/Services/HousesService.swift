//
//  HousesService.swift
//  RomaMVVM
//
//  Created by User on 19.04.2023.
//

import Combine
import Foundation

enum HousesServiceError: Error {
    case networking(NetworkError)
    case noHouses
}

protocol HousesService {
    var houses: [HouseDomainModel] { get }
    func getHouses(pageSize: Int, offset: Int) -> AnyPublisher<[HouseDomainModel], HousesServiceError>
    func updateHouses(pageSize: Int, offset: Int)
}

final class HousesServiceImpl: HousesService {
    var cancellables = Set<AnyCancellable>()

    private(set) lazy var housesPublisher = housesSubject.eraseToAnyPublisher()
    private var housesSubject = CurrentValueSubject<[HouseDomainModel]?, Never>(nil)

    private let housesNetworkService: HousesNetworkService

    var houses: [HouseDomainModel] {
        get {
            guard let houses = housesSubject.value else { return []}
            return houses
        }
    }

    init(housesNetworkService: HousesNetworkService) {
        self.housesNetworkService = housesNetworkService
    }

    func getHouses(pageSize: Int, offset: Int) -> AnyPublisher<[HouseDomainModel], HousesServiceError> {
        housesNetworkService.getHouses(pageSize: pageSize, skip: offset)
            .mapError { HousesServiceError.networking($0) }
            .map { value -> [HouseDomainModel] in
                value.map { HouseDomainModel(model: $0) }
            }
            .handleEvents(receiveOutput: { [unowned self] houses in
                var temporaryHouses = self.houses
                temporaryHouses.append(contentsOf: houses)
                self.housesSubject.value = temporaryHouses
            })
            .eraseToAnyPublisher()
    }

    func updateHouses(pageSize: Int, offset: Int) {
        housesNetworkService.getHouses(pageSize: pageSize, skip: offset)
            .replaceError(with: [])
            .map { value -> [HouseDomainModel] in
                value.map { HouseDomainModel(model: $0) }
            }
            .assignWeakly(to: \.value, on: housesSubject)
            .store(in: &cancellables)
    }
}
