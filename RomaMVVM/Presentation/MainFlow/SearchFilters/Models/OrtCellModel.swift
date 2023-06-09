//
//  OrtCellModel.swift
//  RomaMVVM
//
//  Created by User on 09.06.2023.
//

import Foundation
import Combine

struct OrtCellModel: Hashable {
    let uuid = UUID()
    let ort: CurrentValueSubject<String?, Never>
    
    static func == (lhs: OrtCellModel, rhs: OrtCellModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
