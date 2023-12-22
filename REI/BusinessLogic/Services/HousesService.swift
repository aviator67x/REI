//
//  HousesService.swift
//  REI
//
//  Created by User on 19.04.2023.
//

import Combine
import CombineCocoa
import Foundation

enum HousesServiceError: Error {
    case networking(NetworkError)
    case noHouses
}

protocol HousesService {
    func getHouses(pageSize: Int, offset: Int, searchParameters: [SearchParam]?, sortParameters: [String]?) -> AnyPublisher<[HouseDomainModel], HousesServiceError>
    func searchHouses(_ parameters: [SearchParam]) -> AnyPublisher<[HouseDomainModel], HousesServiceError>
    func saveAd(
        houseImages: [HouseImageModel],
        house: AdCreatingRequestModel
    )
        -> AnyPublisher<HouseResponseModel, HousesServiceError>
    func getHousesCount() -> AnyPublisher<Int, HousesServiceError>
    func getUserAds(ownerId: String) -> AnyPublisher<[HouseDomainModel], HousesServiceError>
    func deleteAd(with id: String) -> AnyPublisher<Void, HousesServiceError>
    func getAvailableHouses(in poligon: String) -> AnyPublisher<[HouseDomainModel], HousesServiceError>
    func getHousesFromCoreData() -> AnyPublisher<[HouseDomainModel]?, HousesServiceError>
    func getMockHouses() -> AnyPublisher<[HouseDomainModel], HousesServiceError>
    func getFilteredHousesCount(_ filters: [SearchParam]) -> AnyPublisher<Int, HousesServiceError>
}

final class HousesServiceImpl: HousesService {
    private let housesNetworkService: HousesNetworkService
    private let fileService: FileServiceProtocol
    private let coreDataService: CoreDataStackProtocol

    private lazy var cancellables = Set<AnyCancellable>()
    init(housesNetworkService: HousesNetworkService, fileService: FileService, coreDataService: CoreDataStackProtocol) {
        self.housesNetworkService = housesNetworkService
        self.fileService = fileService
        self.coreDataService = coreDataService
    }

    func getHousesCount() -> AnyPublisher<Int, HousesServiceError> {
        housesNetworkService.getHousesCount()
            .mapError { HousesServiceError.networking($0) }
            .eraseToAnyPublisher()
    }

    func getHousesFromCoreData() -> AnyPublisher<[HouseDomainModel]?, HousesServiceError> {
        let housesInCoreData = coreDataService.getObjects()
        let housesPublisher = Just(housesInCoreData)
            .setFailureType(to: HousesServiceError.self)
        return housesPublisher.eraseToAnyPublisher()
    }

    func getHouses(pageSize: Int, offset: Int, searchParameters: [SearchParam]?, sortParameters: [String]?) -> AnyPublisher<[HouseDomainModel], HousesServiceError> {
        return housesNetworkService.getHouses(pageSize: pageSize, skip: offset, searchParameters: searchParameters, sortParameters: sortParameters)
            .mapError { HousesServiceError.networking($0) }
            .map { value -> [HouseDomainModel] in
                let houses = value.map { HouseDomainModel(model: $0) }
                if offset == 0 {
                    self.coreDataService.saveObjects(houseModels: houses, isFavourite: nil)
                }
                return houses
            }
            .eraseToAnyPublisher()
    }

    func searchHouses(_ parameters: [SearchParam]) -> AnyPublisher<[HouseDomainModel], HousesServiceError> {
        if let parametersData = try? JSONEncoder().encode(parameters) {
            // Saving to UserDeafaults
            UserDefaults.standard.set(parametersData, forKey: "searchParameters")
            // Saving to FileDirectory
            fileService.saveToDocuments(object: parameters, with: "SearchParameters")
        }

        return housesNetworkService.searchHouses(with: parameters)
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
                [MultipartItem(name: "", fileName: "\(UUID().uuidString).jpeg", data: $0.imageData)]
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
            .mapError { HousesServiceError.networking($0) }
            .map { value -> [HouseDomainModel] in
                value.map { HouseDomainModel(model: $0) }
            }
            .eraseToAnyPublisher()
    }

    func deleteAd(with id: String) -> AnyPublisher<Void, HousesServiceError> {
        housesNetworkService.deleteAd(with: id)
            .mapError { HousesServiceError.networking($0) }
            .eraseToAnyPublisher()
    }

    func getAvailableHouses(in poligon: String) -> AnyPublisher<[HouseDomainModel], HousesServiceError> {
        housesNetworkService.getAvailableHouses(in: poligon)
            .mapError { HousesServiceError.networking($0) }
            .map { value -> [HouseDomainModel] in
                value.map { HouseDomainModel(model: $0) }
            }
            .eraseToAnyPublisher()
    }

    func getMockHouses() -> AnyPublisher<[HouseDomainModel], HousesServiceError> {
        var housesPublisher = Just<[HouseDomainModel]>([])
        if let fileUrl = Bundle.main.url(forResource: "JsonHouses", withExtension: "json") {
            print(fileUrl)
            do {
                let data = try Data(contentsOf: fileUrl)
                do {
                    let responseModel = try JSONDecoder().decode([HouseResponseModel].self, from: data)
                    let domainModel = responseModel.map { HouseDomainModel(model: $0)}
                    housesPublisher = Just(domainModel)
                } catch {
                    debugPrint("Can't decode data with error: \(error)")
                }
            } catch {
                debugPrint("Can't encode JSON")
            }
        }
        return housesPublisher
            .setFailureType(to: HousesServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func getFilteredHousesCount(_ filters: [SearchParam]) -> AnyPublisher<Int, HousesServiceError> {
        housesNetworkService.getFilteredHousesCount(filters)
            .mapError { HousesServiceError.networking($0) }
            .eraseToAnyPublisher()
    }
}
