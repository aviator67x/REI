//
//  MapCellModel.swift
//  RomaMVVM
//
//  Created by User on 02.06.2023.
//

import Foundation

struct MapCellModel: Hashable {
    let addresses: [String]
    
    init(data: [HouseDomainModel]) {
        self.addresses = data.map {[$0.ort, $0.street, String($0.house)].joined(separator: ",")}
    }
}
