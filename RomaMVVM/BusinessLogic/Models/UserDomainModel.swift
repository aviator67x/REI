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
    let email: String
    let imageURL: URL?
    
    init(networkModel: SignInResponse, imageURL: URL? = nil) {
        self.id = networkModel.id
        self.name = networkModel.name
        self.email = networkModel.email
        self.imageURL = imageURL
    }
    
    init(networkModel: UpdateUserResponseModel) {
        self.id = networkModel.id
        self.name = networkModel.name
        self.email = networkModel.email
        self.imageURL = networkModel.imageURL
    }
}
