//
//  RoomsNumberCell.swift
//  RomaMVVM
//
//  Created by User on 29.03.2023.
//

import Foundation
import UIKit

final class RoomsNumberCell: UICollectionViewListCell {
    static let reusedidentifier = String(String(describing: RoomsNumberCell.self))
    
    private let roomsNumberButton = UIButton()
    
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
        roomsNumberButton.backgroundColor = .secondarySystemBackground
        roomsNumberButton.bordered(width: 1, color: .lightGray)
        roomsNumberButton.layer.cornerRadius = 6
        roomsNumberButton.setTitleColor(.black, for: .normal)
    }

    private func setupLayout() {
        contentView.addSubview(roomsNumberButton) {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(3)
            $0.width.equalTo(60)
        }
    }

    private func setupBinding() {}

    func setupCell(with title: String) {
        roomsNumberButton.setTitle(title, for: .normal)
    }
}
