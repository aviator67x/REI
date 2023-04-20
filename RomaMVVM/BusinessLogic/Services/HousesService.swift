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
//    func getHouses(pageSize: Int, offset: Int) -> [HouseDomainModel]?
}

final class HousesServiceImpl: HousesService {
    private(set) lazy var housesPublisher = housesSubject.eraseToAnyPublisher()
    private var housesSubject = CurrentValueSubject<[HouseDomainModel]?, Never>(nil)

    private let housesNetworkService: HousesNetworkService

//    var houses: [HouseDomainModel] = []
//    {
//        housesSubject.value
//    }

    init(housesNetworkService: HousesNetworkService) {
        self.housesNetworkService = housesNetworkService
    }

    func getHouses(pageSize: Int, offset: Int) -> [HouseDomainModel]? {
        var houses: [HouseDomainModel] = []
        housesNetworkService.getHouses(pageSize: pageSize, skip: offset)
            .mapError { HousesServiceError.networking($0) }
            .map { data in
                data.forEach { house in
                    let houseDomain = HouseDomainModel(model: house)
                   houses.append(houseDomain)
                }
            }
        return houses
    }
}
