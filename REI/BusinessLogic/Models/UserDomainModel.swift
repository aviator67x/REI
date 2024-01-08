//
//  UserModel.swift
//  REI
//
//  Created by User on 28.02.2023.
//

import Foundation

struct UserDomainModel: Codable {
    let id: String
    let name: String
    let firstName: String
    let lastName: String
    let nickName: String
    let email: String
    let imageURL: URL?
    var favouriteHouses: [HouseDomainModel]?

    init(networkModel: SignInResponse) {
        self.id = networkModel.id
        self.name = networkModel.name
        self.firstName = ""
        self.lastName = ""
        self.nickName = ""
        self.email = networkModel.email
        self.imageURL = networkModel.imageURL
        self.favouriteHouses = []
    }

    init(networkModel: UpdateUserResponseModel) {
        self.id = networkModel.id
        self.name = networkModel.name
        self.firstName = networkModel.firstName ?? ""
        self.lastName = networkModel.lastName ?? ""
        self.nickName = networkModel.nickName ?? ""
        self.email = networkModel.email
        self.imageURL = networkModel.imageURL
        var domainHouses = [HouseDomainModel]()
        networkModel.favouriteHouses?.forEach {
            favouriteHouse in
            domainHouses.append(HouseDomainModel(model: favouriteHouse))
        }
        self.favouriteHouses = domainHouses
    }

    init(coreDataModel: User) {
        self.id = coreDataModel.id
        self.name = coreDataModel.name
        self.firstName = coreDataModel.firstName
        self.lastName = coreDataModel.lastName
        self.nickName = coreDataModel.nickName
        self.email = coreDataModel.email
        self.imageURL = URL(string: coreDataModel.imageURL)
        self.favouriteHouses = Array(coreDataModel.favouriteHouses) as? [HouseDomainModel]
    }
}
