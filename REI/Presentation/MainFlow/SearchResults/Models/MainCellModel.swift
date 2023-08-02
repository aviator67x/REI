//
//  MainCellModel.swift
//  REI
//
//  Created by User on 21.04.2023.
//

import Foundation

struct MainCellModel: Hashable {
    let uuid = UUID()
    let id: String
    let image: URL?
    let street: String
    let ort: String
    let price: Int
    
    init(id: String, image: URL?, street: String, ort: String, price: Int) {
        self.id = id
        self.image = image
        self.street = street
        self.ort = ort
        self.price = price
    }
    
    init(data: HouseDomainModel) {
        self.id = data.id
        self.image = data.images?.first
        self.street = data.street
        self.ort = data.ort
        self.price = data.price
    }
    
    static func == (lhs: MainCellModel, rhs: MainCellModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

