//
//  SortingParameters.swift
//  REI
//
//  Created by User on 11.08.2023.
//

import Foundation

enum SortingParameters: String, CaseIterable {
    case addressUp = "ort"
    case addressDown = "ort DESC"
    case priceUp = "price"
    case priceDown = "price DESC"
    case dateNewFirst = "created"
    case dateOldFirst = "created DESC"
}
