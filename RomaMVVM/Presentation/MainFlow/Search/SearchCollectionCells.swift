//
//  CollectionCells.swift
//  RomaMVVM
//
//  Created by User on 26.03.2023.
//

import Foundation
import SnapKit
import UIKit
import Combine

class DistanceHeaderView: UICollectionReusableView {
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PriceHeaderView: UICollectionReusableView {
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DistanceCell: UICollectionViewCell {
    static let reusedidentifier = String(String(describing: DistanceCell.self))

    private let distanceLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .groupTableViewBackground
        setupLayout()
        setupUI()
        setupBinding()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        distanceLabel.bordered(width: 1, color: .lightGray)
        distanceLabel.layer.cornerRadius = 6
        distanceLabel.text = "distance"
        distanceLabel.textAlignment = .center
    }

    private func setupLayout() {
        contentView.addSubview(distanceLabel) {
            $0.edges.equalToSuperview()
            $0.width.equalTo(60)
        }
    }
    
    private func setupBinding() {
    }

    func setupCell(with km: String) {
        distanceLabel.text = km
    }
}

class PriceCell: UICollectionViewCell {
    static let reusedidentifier = String(String(describing: PriceCell.self))
    private let priceLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cyan
        setupLayout()
        setupUI()
        setupBinding()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        priceLabel.bordered(width: 1, color: .red)
        priceLabel.layer.cornerRadius = 6
        priceLabel.text = "Pirce in Euro"
    }

    private func setupLayout() {
        contentView.addSubview(priceLabel) {
            $0.edges.equalToSuperview()
            $0.width.equalTo(200)
        }
    }
    
    private func setupBinding() {
    }

    func setupCell(with price: Int) {
        
    }

}

class TypeCell: UICollectionViewListCell {
    static let reusedidentifier = String(String(describing: TypeCell.self))
}

class SquareCell: UICollectionViewListCell {
    static let reusedidentifier = String(String(describing: SquareCell.self))
}

class RoomsNumberCell: UICollectionViewListCell {
    static let reusedidentifier = String(String(describing: RoomsNumberCell.self))
}

class YearCell: UICollectionViewListCell {
    static let reusedidentifier = String(String(describing: YearCell.self))
}

class GarageCell: UICollectionViewListCell {
    static let reusedidentifier = String(String(describing: GarageCell.self))
}
