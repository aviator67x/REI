//
//  UserModel.swift
//  RomaMVVM
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
    let favouriteHouses: [HouseDomainModel]?

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
}
