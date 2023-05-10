//
//  DistanceCell.swift
//  RomaMVVM
//
//  Created by User on 29.03.2023.
//

import Foundation
import UIKit

final class DistanceCell: UICollectionViewCell {
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
        distanceLabel.layer.masksToBounds = true
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

    func setupCell(with model: DistanceCellModel) {
        isSelected = model.isSelected
        distanceLabel.bordered(width: 1, color: isSelected ? .blue : .lightGray)
        distanceLabel.backgroundColor = isSelected ? .systemTeal : .secondarySystemBackground
        switch model.distance {
        case .one:
            distanceLabel.text = isSelected ? " 1 X  " : "+1"
        case .two:
            distanceLabel.text = isSelected ? " 2 X  " : "+2"
        case .five:
            distanceLabel.text = isSelected ? " 5 X  " : "+5"
        case .ten:
            distanceLabel.text = isSelected ? " 10 X  " : "+10"
        case .fifteen:
            distanceLabel.text = isSelected ? " 15 X  " : "+15"
        case .thirty:
            distanceLabel.text = isSelected ? " 30 X  " : "30"
        case .fifty:
            distanceLabel.text = isSelected ? " 50 X  " : "+50"
        case .oneHundred:
            distanceLabel.text = isSelected ? " 100 X  " : "+100"
        }
    }
}
