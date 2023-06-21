//
//  UISegmentControl.swift
//  RomaMVVM
//
//  Created by User on 03.02.2023.
//

import UIKit

extension UISegmentedControl {
    func removeBorders() {
        guard let backgroundColor = UIColor(named: "backgroundColor") else { return }
        setBackgroundImage(imageWithColor(color: backgroundColor),
                           for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: backgroundColor),
                           for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear),
                        forLeftSegmentState: .normal,
                        rightSegmentState: .normal, barMetrics: .default)
    }

    private func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor);
        context?.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
}
