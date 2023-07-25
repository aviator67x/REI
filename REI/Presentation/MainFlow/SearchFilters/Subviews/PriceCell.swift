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
    private let minTextField = TextField()
    private let maxTextField = TextField()
    private let middleLabel = UILabel()

    private var minPrice = 0
    private var maxPrice = 0

    private var cancellables = Set<AnyCancellable>()

    var minValue: ((String) -> Void)?
    var maxValue: ((String) -> Void)?

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
        minTextField.layer.cornerRadius = 3
        minTextField.layer.borderColor = UIColor.lightGray.cgColor
        minTextField.layer.borderWidth = 1
        minTextField.keyboardType = .decimalPad
        minTextField.addDoneButtonOnKeyboard()
        minTextField.delegate = self

        maxTextField.placeholder = " Max price"
        maxTextField.layer.cornerRadius = 3
        maxTextField.layer.borderColor = UIColor.lightGray.cgColor
        maxTextField.layer.borderWidth = 1
        maxTextField.keyboardType = .decimalPad
        maxTextField.addDoneButtonOnKeyboard()
        maxTextField.delegate = self

        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 16
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

    func setupCell(with model: PriceCellModel) {
        minPrice = Int(model.minPrice) ?? 0
        maxPrice = Int(model.maxPrice) ?? 0
        minTextField.text = model.minPrice
        minTextField.textPublisher
            .dropFirst()
            .unwrap()
            .removeDuplicates()
            .sinkWeakly(self, receiveValue: { (self, min) in
                self.minPrice = Int(min) ?? 0
                if self.maxPrice != 0 &&
                    self.minPrice < self.maxPrice || self.maxPrice == 0
                {
                    self.minValue?(min)
                }
            })
            .store(in: &cancellables)

        maxTextField.text = model.maxPrice
        maxTextField.textPublisher
            .dropFirst()
            .unwrap()
            .removeDuplicates()
            .sinkWeakly(self, receiveValue: { (self, max) in
                self.maxPrice = Int(max) ?? 0
                if self.minPrice != 0,
                   self.maxPrice < self.minPrice {
                    self.maxValue?(self.minTextField.text ?? "")
                } else {
                    self.maxValue?(max)
                }
            })
            .store(in: &cancellables)
    }
}

extension PriceCell: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        switch textField {
        case minTextField:
            if let text = minTextField.text,
               let textRange = Range(range, in: text),
               maxPrice != 0,
               maxPrice <= minPrice
            {
                minTextField.text = text.replacingCharacters(
                    in: textRange,
                    with: ""
                )
            }
        default:
            break
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case maxTextField:
            if maxPrice <= minPrice {
                maxTextField.text = minTextField.text
            }
           
        default:
            break
        }
    }
}
