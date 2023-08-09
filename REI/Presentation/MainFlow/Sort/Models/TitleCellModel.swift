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
    let title: String
    var isCheckmarkHidden: Bool
    
    var newTitle: String {
        switch sectionType {
        case .address:
           return "Address"
        case .price:
           return "Price"
        }
    }
}
