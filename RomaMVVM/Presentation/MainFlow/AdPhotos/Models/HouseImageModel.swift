//
//  HouseImageModel.swift
//  RomaMVVM
//
//  Created by User on 26.05.2023.
//

import Foundation

struct HouseImageModel {
    let imageData: Data
    var imageLink: URL? = nil
    let imageID: UUID = UUID()
}
