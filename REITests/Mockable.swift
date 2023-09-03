//
//  File.swift
//  REITests
//
//  Created by User on 03.09.2023.
//

import Foundation

protocol Mocable: AnyObject {
    var bundle: Bundle { get }
    func loadJson<T: Decodable>(fileName: String, type: T.Type) -> [T]
}

extension Mocable: {
    var bundle: Bundle {
        Bundle(for: type(of: self))
    }
    
    func loadJson<T: Decodable>(fileName: String, type: T.Type) -> [T] {
        guard let path = Bundle(url(forResource: fileName, withExtension: "json")) else {
            fatalError("Failed to load JSON file")
        }
        do {
            let data = Data(contentsOf: path)
            let decodedData = try JSONDecoder().decode([T.Type], from: data)
            return decodedData
        } catch {
            fatalError("Failed to fetch or decode data")
        }
    }
}
