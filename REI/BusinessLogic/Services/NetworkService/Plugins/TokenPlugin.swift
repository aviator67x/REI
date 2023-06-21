//
//  AuthPlugin.swift
//  MVVMSkeleton
//
//  Created by user on 14.12.2021.
//

import Foundation

final class TokenPlugin: Plugin {
    let tokenStorage: TokenStorageService
    
    init(tokenStorage: TokenStorageService) {
        self.tokenStorage = tokenStorage
    }
    
    func modifyRequest(_ request: inout URLRequest) {
        guard let token = tokenStorage.token?.value else {
            return
        }
        request.setValue(token, forHTTPHeaderField: "user-token")
    }
}
