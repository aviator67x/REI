//
//  RoomsNumberCell.swift
//  RomaMVVM
//
//  Created by User on 29.03.2023.
//

import Foundation
import UIKit

final class RoomsNumberCell: UICollectionViewListCell {    
    private let roomsNumberLabel = UILabel()
    
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
        roomsNumberLabel.backgroundColor = .secondarySystemBackground
        roomsNumberLabel.bordered(width: 1, color: .lightGray)
        roomsNumberLabel.layer.cornerRadius = 6
        roomsNumberLabel.textAlignment = .center
    }

    private func setupLayout() {
        contentView.addSubview(roomsNumberLabel) {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(3)
            $0.width.equalTo(60)
        }
    }

    private func setupBinding() {}

    func setupCell(with title: SearchRequestModel.NumberOfRooms) {
        switch title {
        case .one:
            roomsNumberLabel.text = "1+"
        case .two:
            roomsNumberLabel.text = "2+"
        case .three:
            roomsNumberLabel.text = "3+"
        case .four:
            roomsNumberLabel.text = "4+"
        case .five:
            roomsNumberLabel.text = "5+"
        }
        
    }
}
