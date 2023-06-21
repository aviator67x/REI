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
    func getHouses(pageSize: Int, offset: Int) -> AnyPublisher<[HouseDomainModel], HousesServiceError>
    func searchHouses(_ parameters: [SearchParam]) -> AnyPublisher<[HouseDomainModel], HousesServiceError>
    func saveAd(
        houseImages: [HouseImageModel],
        house: AdCreatingRequestModel
    )
        -> AnyPublisher<HouseResponseModel, HousesServiceError>
    func getHousesCount() -> AnyPublisher<Int, HousesServiceError>
    func getUserAds(ownerId: String) -> AnyPublisher<[HouseDomainModel], HousesServiceError>
    func deleteAd(with id: String) -> AnyPublisher<Void, HousesServiceError>
}

final class HousesServiceImpl: HousesService {
    private let housesNetworkService: HousesNetworkService
    
    init(housesNetworkService: HousesNetworkService) {
        self.housesNetworkService = housesNetworkService
    }
    
    func getHousesCount() -> AnyPublisher<Int, HousesServiceError> {
        housesNetworkService.getHousesCount()
            .mapError { HousesServiceError.networking($0)}
            .eraseToAnyPublisher()
    }
    
    func getHouses(pageSize: Int, offset: Int) -> AnyPublisher<[HouseDomainModel], HousesServiceError> {
        housesNetworkService.getHouses(pageSize: pageSize, skip: offset)
            .mapError { HousesServiceError.networking($0) }
            .map { value -> [HouseDomainModel] in
                value.map { HouseDomainModel(model: $0) }
            }
            .eraseToAnyPublisher()
    }
    
    func searchHouses(_ parameters: [SearchParam]) -> AnyPublisher<[HouseDomainModel], HousesServiceError> {
        housesNetworkService.searchHouses(with: parameters)
            .mapError { HousesServiceError.networking($0) }
            .map { value -> [HouseDomainModel] in
                value.map { HouseDomainModel(model: $0) }
            }
            .eraseToAnyPublisher()
    }
    
    func saveAd(
        houseImages: [HouseImageModel],
        house: AdCreatingRequestModel
    )
    -> AnyPublisher<HouseResponseModel, HousesServiceError>
    {
        houseImages
            .map {
                [MultipartItem(name: "", fileName: "\(UUID().uuidString).png", data: $0.imageData)]
            }
            .map {
                housesNetworkService.saveHouseImage(image: $0)
                    .eraseToAnyPublisher()
                    .mapError { HousesServiceError.networking($0) }
            }
            .publisher
            .flatMap { $0 }
            .collect()
            .flatMap { images -> AnyPublisher<HouseResponseModel, HousesServiceError> in
                var adModel = house
                adModel.images = images.map { $0.imageURL }
                return self.housesNetworkService.saveAd(house: adModel)
                    .mapError { HousesServiceError.networking($0) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getUserAds(ownerId: String) -> AnyPublisher<[HouseDomainModel], HousesServiceError> {
        
        return housesNetworkService.getUserAds(ownerId: ownerId)
            .mapError { HousesServiceError.networking($0)}
            .map { value -> [HouseDomainModel] in
                value.map { HouseDomainModel(model: $0) }
            }
                .eraseToAnyPublisher()
    }
    
    func deleteAd(with id: String) -> AnyPublisher<Void, HousesServiceError> {
        housesNetworkService.deleteAd(with: id)
            .mapError { HousesServiceError.networking($0)}
            .eraseToAnyPublisher()
    }
}
