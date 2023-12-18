//
//  UIView+downSizing.swift
//  REI
//
//  Created by User on 15.12.2023.
//

import Foundation

func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
      let scale = newHeight / self.size.height
      let newWidth = self.size.width * scale
      let newSize = CGSize(width: newWidth, height: newHeight)
      let renderer = UIGraphicsImageRenderer(size: newSize)

      return renderer.image { _ in
          self.draw(in: CGRect(origin: .zero, size: newSize))
      }
  }
