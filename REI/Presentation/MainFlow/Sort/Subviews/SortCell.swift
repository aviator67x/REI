//
//  SortCell.swift
//  REI
//
//  Created by User on 07.08.2023.
//

import UIKit

final class SortCell: UITableViewCell {
    // MARK: - SubViews
    let nameLabel = UILabel()
    let arrowImageView = UIImageView()
    let circleImageView = UIImageView()

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

    func setup(_ model: SortCellModel) {
        nameLabel.text = model.name
        nameLabel.textColor = model.isSelected ? .blue : .black
        isHidden = model.isHidden
        circleImageView.image = model.isSelected ? UIImage(systemName: "record.circle") : UIImage(systemName: "circle")
        arrowImageView.image = UIImage(systemName: model.arrowImageName)
        arrowImageView.tintColor = model.isSelected ? .blue : .black
    }
}

// MARK: - private extension
private extension SortCell {
    func setupUI() {
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }

    func setupLayout() {
        contentView.addSubview(arrowImageView) {
            $0.leading.equalToSuperview().offset(10)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.size.equalTo(14)
        }

        contentView.addSubview(nameLabel) {
            $0.leading.equalTo(arrowImageView.snp.trailing).offset(10)
            $0.top.bottom.equalToSuperview().inset(10)
        }

        contentView.addSubview(circleImageView) {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
}
