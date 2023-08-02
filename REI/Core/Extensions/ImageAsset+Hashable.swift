//
//  ImageAssets+Hashable.swift
//  REI
//
//  Created by User on 17.03.2023.
//

import Foundation

extension ImageAsset: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(image)
    }
    
    static func == (lhs: ImageAsset, rhs: ImageAsset) -> Bool {
           return lhs.image == rhs.image
       }
}
