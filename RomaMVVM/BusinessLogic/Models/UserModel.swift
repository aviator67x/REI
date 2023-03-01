//
//  UserModel.swift
//  RomaMVVM
//
//  Created by User on 28.02.2023.
//

import Foundation

struct UserModel: Codable {
    let id: String
    let name: String
    let email: String
    let accessToken: String
    
    init(networkModel: SignInResponse) {
        self.id = networkModel.id
        self.name = networkModel.name
        self.email = networkModel.email
        self.accessToken = networkModel.accessToken
    }
}
