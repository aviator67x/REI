//
//  PriceCell.swift
//  RomaMVVM
//
//  Created by User on 29.03.2023.
//

import Combine
import Foundation
import UIKit

final class PriceCell: UICollectionViewCell {
    private let stack = UIStackView()
    private(set) var minTextField = UITextField()
    private let maxTextField = UITextField()
    private let middleLabel = UILabel()

    private var cancellables = Set<AnyCancellable>()

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

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables = []
    }

    private func setupUI() {
        middleLabel.text = "to:"
        minTextField.placeholder = " 0"
        minTextField.layer.cornerRadius = 2
        minTextField.layer.borderColor = UIColor.lightGray.cgColor
        minTextField.layer.borderWidth = 1
        minTextField.keyboardType = .decimalPad

        maxTextField.placeholder = " Max price"
        maxTextField.layer.cornerRadius = 2
        maxTextField.layer.borderColor = UIColor.lightGray.cgColor
        maxTextField.layer.borderWidth = 1
        maxTextField.keyboardType = .decimalPad

        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 16

        contentView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        contentView.addGestureRecognizer(tap)
    }

    private func setupLayout() {
        contentView.addSubview(stack) {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(23)
            $0.leading.equalToSuperview().offset(35)
        }

        minTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalTo(140)
        }

        maxTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalTo(140)
        }

        stack.addArrangedSubviews([minTextField, middleLabel, maxTextField])
    }

    private func setupBinding() {}

    @objc
    private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        minTextField.resignFirstResponder()
        maxTextField.resignFirstResponder()
    }

    func setupCell(with model: PriceCellModel) {
        minTextField.textPublisher
            .dropFirst()
            .assignWeakly(to: \.value, on: model.minPrice)
            .store(in: &cancellables)
        maxTextField.textPublisher
            .dropFirst()
            .assignWeakly(to: \.value, on: model.maxPrice)
            .store(in: &cancellables)
    }
}
