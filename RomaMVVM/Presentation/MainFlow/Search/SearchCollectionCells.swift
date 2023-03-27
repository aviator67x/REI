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

class DistanceCell: UICollectionViewListCell {
    static let reusedidentifier = String(String(describing: DistanceCell.self))
    var labelDidTap: (() -> Bool)?
    private let cancelables = Set<AnyCancellable>()
    @Published var tapDidHappen: Bool = false

    private let stack = UIStackView()
    private let criteriaLablel = UILabel()
    private let oneKmLabel = UILabel()
    private let isOneChosen = false
    private let fiveKmLabel = UILabel()
    private let isFiveChosen = false
    private let tenKmLabel = UILabel()
    private let isTenChosen = false
    private let thirtyKmLabel = UILabel()
    private let isThirtyChosen = false
    private let fiftyKmLabel = UILabel()
    private let isFiftyChosen = false
    private let hundredKmLabel = UILabel()
    private let isHundredChosen = false
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        setupLayout()
        setupUI()
        setupCell()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 3

        criteriaLablel.text = " + Distance in km"
        oneKmLabel.text = isOneChosen ? "+1 X" : "+1"
        oneKmLabel.backgroundColor = isOneChosen ? UIColor.systemYellow : UIColor.lightGray
        fiveKmLabel.text = isFiveChosen ? "+5 X" : "+5"
        fiveKmLabel.backgroundColor = isFiveChosen ? UIColor.systemYellow : UIColor.lightGray
        tenKmLabel.text = isTenChosen ? "+10 X" : "+10"
        tenKmLabel.backgroundColor = isTenChosen ? UIColor.systemYellow : UIColor.lightGray
        thirtyKmLabel.text = isThirtyChosen ? "+30 X" : "+30"
        thirtyKmLabel.backgroundColor = isThirtyChosen ? UIColor.systemYellow : UIColor.lightGray
        fiftyKmLabel.text = isFiftyChosen ? "+50 X" : "+50"
        fiftyKmLabel.backgroundColor = isFiftyChosen ? UIColor.systemYellow : UIColor.lightGray
        hundredKmLabel.text = isHundredChosen ? "+100 X" : "+100"
        hundredKmLabel.backgroundColor = isHundredChosen ? UIColor.systemYellow : UIColor.lightGray
        [oneKmLabel, fiveKmLabel, tenKmLabel, thirtyKmLabel, fiftyKmLabel, hundredKmLabel].forEach { label in
            label.rounded(6)
            label.bordered(width: 1, color: .gray)
            label.snp.makeConstraints {
                $0.height.equalTo(25)
                $0.width.equalTo(50)
            }
        }
    }

    private func setupLayout() {
        contentView.addSubview(criteriaLablel) {
            $0.leading.top.equalToSuperview().inset(10)
        }
        contentView.addSubview(stack) {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(criteriaLablel.snp.bottom).offset(5)
            $0.bottom.equalToSuperview().inset(10)
        }

        stack
            .addArrangedSubviews([oneKmLabel, fiveKmLabel, tenKmLabel, thirtyKmLabel, fiftyKmLabel, hundredKmLabel])
    }
    
    private func setupBinding() {
        [oneKmLabel, fiveKmLabel, tenKmLabel, thirtyKmLabel, fiftyKmLabel, hundredKmLabel].forEach { label in
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onLabelTap))
            label.addGestureRecognizer(tapRecognizer)
        }
       
    }
    
    @objc
    private func onLabelTap() {}

    func setupCell() {
       
    }
}

class PriceCell: UICollectionViewListCell {
    static let reusedidentifier = String(String(describing: PriceCell.self))
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
