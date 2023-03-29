//
//  PriceHeaderView.swift
//  RomaMVVM
//
//  Created by User on 29.03.2023.
//

import Foundation
import UIKit

final class PriceHeaderView: UICollectionReusableView {
    static let identifier = String(describing: DistanceHeaderView.self)
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)

        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Euro Pirce category"

        addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

