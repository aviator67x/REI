//
//  UserDefaults+coding.swift
//  REI
//
//  Created by User on 03.03.2023.
//

import Foundation

extension UserDefaults {
    func encode<T: Encodable>(data: T, key: String) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(data) {
            set(encodedData, forKey: key)
        }
    }

    func decode<T: Decodable>(type: T.Type, data: Data) -> T? {
        let decoder = JSONDecoder()
        let decodedData = try? decoder.decode(type, from: data)
        return decodedData
    }
}
