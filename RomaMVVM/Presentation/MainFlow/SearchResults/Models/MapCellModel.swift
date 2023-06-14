//
//  MapCellModel.swift
//  RomaMVVM
//
//  Created by User on 02.06.2023.
//

import Foundation

struct MapCellModel: Hashable {
    let points: [Address]
    
    init(data: [HouseDomainModel]) {       
        self.points = data.map { Address(address: [$0.ort, $0.street, String($0.house)].joined(separator: ", "), location: $0.location)}
    }
}

struct Address: Hashable {
    let address: String
    let location: Location
}
