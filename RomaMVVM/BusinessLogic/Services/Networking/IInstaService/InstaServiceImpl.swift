//
//  InstaServiceImpl.swift
//  RomaMVVM
//
//  Created by User on 30.01.2023.
//

import Foundation
import Combine
import CombineNetworking

class InstaServiceImpl {
    private var provider: CNProvider<InstaAPIRequestBuilder, CNErrorHandlerImpl>
    
    init(_ provider: CNProvider<InstaAPIRequestBuilder, CNErrorHandlerImpl>) {
        self.provider = provider
    }
}

extension InstaServiceImpl: InstaService {
    func sendVerificationCode(emailOrPhone: String) -> AnyPublisher<String, CNError> {
        provider.perform(.sendVerification(code: emailOrPhone))
    }
    
    func logInForAccessToken(emailOrPhone: String, password: String) -> AnyPublisher<String, CNError> {
        provider.perform(.requestForAccessToken(phoneOrEmail: emailOrPhone, password: password))
            .eraseToAnyPublisher()
    }
}
   

