//
//  TitleCellModel.swift
//  REI
//
//  Created by User on 08.08.2023.
//

import Foundation

struct TitleCellModel: Hashable {
    let sectionType: SortSection
    let id = UUID()
    var isCheckmarkHidden: Bool
    
    var title: String {
        switch sectionType {
        case .address:
           return "Address"
        case .price:
           return "Price"
        case .date:
            return "Date"
        }
    }
}
