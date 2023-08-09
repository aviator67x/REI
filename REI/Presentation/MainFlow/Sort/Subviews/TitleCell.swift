//
//  SortCell.swift
//  REI
//
//  Created by User on 07.08.2023.
//

import UIKit

final class TitleCell: UITableViewCell {
    // MARK: - SubViews
    let titleLabel = UILabel()
    let checkmarkImageView = UIImageView()

    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(_ model: TitleCellModel) {
        titleLabel.text = model.title
        checkmarkImageView.isHidden = model.isCheckmarkHidden
    }
}

// MARK: - private extension
private extension TitleCell {
    func setupUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        checkmarkImageView.image = UIImage(systemName: "chevron.down")
        checkmarkImageView.tintColor = .black
    }
    
    func setupLayout() {
        contentView.addSubview(titleLabel) {
            $0.leading.equalToSuperview().offset(10)
            $0.top.bottom.equalToSuperview().inset(10)
        }

        contentView.addSubview(checkmarkImageView) {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
}
