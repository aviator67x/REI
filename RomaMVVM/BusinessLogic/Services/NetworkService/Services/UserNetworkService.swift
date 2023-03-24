//
//  UserService.swift
//  RomaMVVM
//
//  Created by User on 25.02.2023.
//

import Foundation
import Combine

protocol UserNetworkService {
    func deleteUser(id: String) -> AnyPublisher<Void, NetworkError>
    func logOut(token: String) -> AnyPublisher<Void, NetworkError>
    func saveAvatar(image: [MultipartItem]) -> AnyPublisher<UpdateAvatarResponceModel, NetworkError>
    func updateUser(_ updateUserRequetModel: UpdateUserRequestModel) -> AnyPublisher<UpdateUserResponseModel, NetworkError>
}

final class UserNetworkServiceImpl<NetworkProvider: NetworkServiceProvider> where NetworkProvider.E == UserEndPoint {
    let userProvider: NetworkProvider
    
    init(userProvider: NetworkProvider) {
        self.userProvider = userProvider
    }
}
extension UserNetworkServiceImpl: UserNetworkService {
    func deleteUser(id: String) -> AnyPublisher<Void, NetworkError> {
        return userProvider.execute(endpoint: .deleteUser(id: id))
    }
    
    func logOut(token: String) -> AnyPublisher<Void, NetworkError> {
        return userProvider.execute(endpoint: .logOut(token: token))
    }
    
    func saveAvatar(image: [MultipartItem]) -> AnyPublisher<UpdateAvatarResponceModel, NetworkError> {
        return userProvider.execute(endpoint: .addAvatar(image: image))
    }
     
    func updateUser(_ userUpdateRequestModel: UpdateUserRequestModel) -> AnyPublisher<UpdateUserResponseModel, NetworkError> {
        return userProvider.execute(endpoint: .update(user: userUpdateRequestModel))
    }
}
