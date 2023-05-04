//
//  DistanceCell.swift
//  RomaMVVM
//
//  Created by User on 29.03.2023.
//

import Foundation
import UIKit

final class DistanceCell: UICollectionViewCell {
    static let reusedidentifier = String(String(describing: DistanceCell.self))

    private let distanceLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupUI()
        setupBinding()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        distanceLabel.backgroundColor = .secondarySystemBackground
        distanceLabel.bordered(width: 1, color: .lightGray)
        distanceLabel.layer.cornerRadius = 6
        distanceLabel.textAlignment = .center
    }

    private func setupLayout() {
        contentView.addSubview(distanceLabel) {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(3)
            $0.width.equalTo(60)
        }
    }

    private func setupBinding() {}

    func setupCell(with km: SearchRequestModel
        .Distance) {
            switch km {
            case .one:
                distanceLabel.text = "+1"
            case .two:
                distanceLabel.text = "+2"
            case .five:
                distanceLabel.text = "+5"
            case .ten:
                distanceLabel.text = "+10"
            case .fifteen:
                distanceLabel.text = "+15"
            case .thirty:
                distanceLabel.text = "+30"
            case .fifty:
                distanceLabel.text = "+50"
            case .oneHundred:
                distanceLabel.text = "+100"
            }
    }
}
