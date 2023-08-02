//
//  FavouriteCell.swift
//  REI
//
//  Created by User on 11.05.2023.
//

import Foundation
import Kingfisher
import UIKit

final class FavouriteCell: UICollectionViewListCell {
    private let imageView = UIImageView()
    private let streetLabel = UILabel()
    private let ortLabel = UILabel()
    private let sqmLabel = UILabel()
    private let spacer = UIView()
    private let priceValueLabel = UILabel()
    private let stackView = UIStackView()
    private let signsButton = UIButton()
    private let separatorView = UIView()

    var heartButtonDidTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        stackView.axis = .vertical
        stackView.spacing = 1

        [streetLabel, ortLabel, sqmLabel, priceValueLabel].forEach { label in
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        }

        let buttonTitle = "\u{2B6F}  \u{95E8} \u{27C1}"
        signsButton.setTitle(buttonTitle, for: .normal)

        separatorView.backgroundColor = .white
    }

    private func setupLayout() {
        contentView.addSubview(imageView) {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }

        contentView.addSubview(separatorView) {
            $0.top.equalTo(imageView.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(4)
        }

        contentView.addSubview(stackView) {
            $0.leading.bottom.equalToSuperview().inset(20)
        }

        spacer.snp.makeConstraints {
            $0.height.equalTo(10)
        }

        stackView.addArrangedSubviews([streetLabel, ortLabel, sqmLabel, spacer, priceValueLabel])

        contentView.addSubview(signsButton) {
            $0.trailing.bottom.equalToSuperview().inset(20)
        }
    }

    func setupCell(_ model: PhotoCellModel) {
        imageView.kf.setImage(with: model.image, placeholder: UIImage(systemName: "house.lodge.circle"))
        streetLabel.text = model.street
        ortLabel.text = model.ort
        sqmLabel.text = "\(model.livingArea) sqm / \(model.square) sqm \u{00B7} \(model.numberOfRooms) rooms"
        priceValueLabel.text = "\u{20AC} \(String(model.price)) k.k."
    }
}