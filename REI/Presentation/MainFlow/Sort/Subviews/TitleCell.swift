//
//  SortCell.swift
//  REI
//
//  Created by User on 07.08.2023.
//

import UIKit

final class TitleCell: UITableViewCell {
    // MARK: - SubViews
    let nameLabel = UILabel()
    let checkmarkImageView = UIImageView()

    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(_ model: TitleCellModel) {
        backgroundColor = .red
        nameLabel.text = model.title
        checkmarkImageView.isHidden = model.isCheckmarkHidden
        checkmarkImageView.image = UIImage(systemName: "checkmark")
    }
}

// MARK: - private extension
private extension TitleCell {
    func setupLayout() {
        contentView.addSubview(nameLabel) {
            $0.leading.equalToSuperview().offset(10)
            $0.top.bottom.equalToSuperview().inset(10)
        }

        contentView.addSubview(checkmarkImageView) {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
//            $0.size.equalTo(30)
        }
    }
}
