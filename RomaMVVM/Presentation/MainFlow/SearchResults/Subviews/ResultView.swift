//
//  ResultView.swift
//  RomaMVVM
//
//  Created by User on 21.04.2023.
//

import Foundation
import UIKit

final class ResultView: UIView {
    private let countryLabel = UILabel()
    private let resultLabel = UILabel()
    private let filterCounterLabel = UILabel()
    private let filterLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        countryLabel.textAlignment = .left
        countryLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        countryLabel.textColor = .systemBlue
        countryLabel.text = "Country"

        resultLabel.textAlignment = .left
        resultLabel.font = UIFont.systemFont(ofSize: 14)
        resultLabel.text = "125 results in find"

        filterCounterLabel.backgroundColor = .orange
        filterCounterLabel.textAlignment = .center
        filterCounterLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        filterCounterLabel.textColor = .white
        filterCounterLabel.rounded(7)
        filterCounterLabel.text = "5"

        filterLabel.textAlignment = .center
        filterLabel.font = UIFont.systemFont(ofSize: 14)
        filterLabel.text = "filters"
    }

    private func setupLayout() {
        addSubview(countryLabel) {
            $0.leading.top.equalToSuperview().offset(16)
        }
        addSubview(resultLabel) {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(countryLabel.snp.bottom)
            $0.bottom.equalToSuperview().inset(16)
        }

        let stack = UIStackView()
        stack.distribution = .fill
        stack.spacing = 5

        addSubview(stack) {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        filterCounterLabel.snp.makeConstraints {
            $0.width.equalTo(20)
        }

        stack.addArrangedSubviews([filterCounterLabel, filterLabel])
    }

    func setup(with model: ResultViewModel) {
        countryLabel.text = "\(model.country)"
        resultLabel.text = "\(model.result) results in find"
        filterCounterLabel.text = "\(model.filters)"
    }
}
