//
//  UIImageView+setImage.swift
//  RomaMVVM
//
//  Created by User on 14.03.2023.
//

import Foundation
import UIKit

enum ImageResource: Hashable {
    case imageURL(URL?)
    case imageData(Data)
    case imageAsset(ImageAsset)
    case systemImage(String)
}

extension UIImageView {
    func setIMage(imageResource: ImageResource) {
        switch imageResource {
        case .imageURL(let url):
            self.kf.setImage(with: url)
            
        case .imageData(let data):
            self.image = UIImage(data: data)
            
        case .imageAsset(let imageAsset):
            self.image = imageAsset.image
            
        case .systemImage(let name):
            self.image = UIImage(systemName: name)
        }
    }
}
