//
//  FileManager.swift
//  REI
//
//  Created by User on 17.08.2023.
//

import Foundation

protocol FileServiceProtocol {
    func saveToDocuments<T: Encodable>(object: T, with filename: String)
    func readDataFromDocument<T: Decodable>(filename: String, decodingType: T)
}

final class FileService: FileServiceProtocol {
   private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        return paths[0]
    }
    
    private func encodeToData<T: Encodable>(parameters: T) -> Data? {
        try? JSONEncoder().encode(parameters)
    }
    
    private func saveDataToDocuments(_ data: Data, jsonFilename: String) {

        let jsonFileURL = getDocumentsDirectory().appendingPathComponent(jsonFilename)
        do {
            try data.write(to: jsonFileURL)
        } catch {
            print("Error = \(error)")
        }
    }
    
    func readDataFromDocument<T: Decodable>(filename: String, decodingType: T) {
        let jsonFileURL = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let data = try Data.init(from: jsonFileURL as! Decoder)
            do {
                let parameters = try JSONDecoder().decode([SearchParam].self, from: data)
            } catch {
                debugPrint("Deconging error: \(error)")
            }
        } catch {
            debugPrint("Converting to Data error: \(error)")
        }
        
    }
    
    func saveToDocuments<T: Encodable>(object: T, with filename: String) {
        guard let data = encodeToData(parameters: object) else {
            return
        }
        saveDataToDocuments(data, jsonFilename: filename)
    }
    
   
}
