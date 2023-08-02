//
//  KeychainService.swift
//  REI
//
//  Created by User on 01.04.2023.
//

import Foundation
import KeychainAccess

final class KeychainService {
    let keychain = Keychain()

    func saveObjectToKeychain(_ object: String, forKey: String) {
        keychain[forKey] = object
    }

    func getObjectFromKeychain(forKey: String) -> String? {
        return keychain[forKey]
    }

    func clearObjectInKeychain(forKey: String) {
        do {
            try keychain.remove(forKey)
        } catch {
            print(error.localizedDescription)
        }
    }
}
