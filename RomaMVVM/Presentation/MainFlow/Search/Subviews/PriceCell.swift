//
//  PriceCell.swift
//  RomaMVVM
//
//  Created by User on 29.03.2023.
//

import Foundation
import UIKit
import Combine

final class PriceCell: UICollectionViewCell {
    static let reusedidentifier = String(String(describing: PriceCell.self))
    
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
        
        maxTextField.placeholder = " Max price"
        maxTextField.layer.cornerRadius = 2
        maxTextField.layer.borderColor = UIColor.lightGray.cgColor
        maxTextField.layer.borderWidth = 1
        
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

    private func setupBinding() {
    }

    func setupCell(with model: PriceCellModel) {
       minTextField.textPublisher
            .assignWeakly(to: \.value, on: model.minPrice)
            .store(in: &cancellables)
        maxTextField.textPublisher
            .assignWeakly(to: \.value, on: model.maxPrice)
            .store(in: &cancellables)
    }
}
