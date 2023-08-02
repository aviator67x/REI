//
//  UIImageView+setImage.swift
//  REI
//
//  Created by User on 14.03.2023.
//

import Foundation
import UIKit
import Kingfisher

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
            self.kf.setImage(with: url, placeholder: UIImage(systemName: "person.circle"))
            
        case .imageData(let data):
            self.image = UIImage(data: data)
            
        case .imageAsset(let imageAsset):
            self.image = imageAsset.image
            
        case .systemImage(let name):
            self.image = UIImage(systemName: name)
        }
    }
}
