//
//  SquareCellModel.swift
//  REI
//
//  Created by User on 01.05.2023.
//

import Foundation
import Combine


struct SquareCellModel: Hashable {
    let uuid = UUID()
//    let minSquare: CurrentValueSubject<String?, Never>
//    let maxSquare: CurrentValueSubject<String?, Never>
    let minSquare: String
    let maxSquare: String

    static func == (lhs: SquareCellModel, rhs: SquareCellModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
