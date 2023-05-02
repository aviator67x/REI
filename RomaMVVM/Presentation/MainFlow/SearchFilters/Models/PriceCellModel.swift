//
//  PriceCellModel.swift
//  RomaMVVM
//
//  Created by User on 01.05.2023.
//

import Foundation
import Combine

struct PriceCellModel: Hashable {
    let uuid = UUID()
    let minPrice: CurrentValueSubject<String?, Never>
    let maxPrice: CurrentValueSubject<String?, Never>

    static func == (lhs: PriceCellModel, rhs: PriceCellModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
