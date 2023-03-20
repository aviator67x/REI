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
    let imageURL: String?
    
    init(networkModel: SignInResponse, imageURL: String? = nil) {
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
