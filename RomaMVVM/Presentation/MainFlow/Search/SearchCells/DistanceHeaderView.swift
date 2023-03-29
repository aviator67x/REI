//
//  DistanceHeaderView.swift
//  RomaMVVM
//
//  Created by User on 29.03.2023.
//

import Foundation
import UIKit

final class DistanceHeaderView: UICollectionReusableView {
    static let identifier = "DistanceHeader"
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)

        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "+ Distance in km"

        addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(label) {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.bottom.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

