//
//  SortTable.swift
//  REI
//
//  Created by User on 07.08.2023.
//

import Foundation

struct SortTable: Hashable {
    var section: SortSection
    var items: [SortItem]
}

enum SortSection: Hashable {
    case button
}

enum SortItem: Hashable {
case title(model: TitleCellModel)
case address(model: SortCellModel)
}
