//
//  CollectionCells.swift
//  REI
//
//  Created by User on 21.03.2023.
//

import Foundation
import UIKit

final class ButtonCell: UICollectionViewCell {
    static let identifier = "ButtonCell"
    let titleLable = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
        setupCell()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(titleLable) {
            $0.center.equalToSuperview()
        }
    }
    
    func setupCell() {
        titleLable.text = "Log Out"
        titleLable.font = UIFont.systemFont(ofSize: 20)
        titleLable.textColor = .red
    }
}
