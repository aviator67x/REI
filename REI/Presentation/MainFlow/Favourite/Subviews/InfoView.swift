//
//  InfoView.swift
//  REI
//
//  Created by User on 04.05.2023.
//

import Foundation
import UIKit

final class InfoView: UIView {
    private let titleLabel = UILabel()
    private let resultLabel = UILabel()

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
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.text = "You have added"

        resultLabel.textAlignment = .left
        resultLabel.font = UIFont.systemFont(ofSize: 14)
    }

    private func setupLayout() {
        addSubview(titleLabel) {
            $0.leading.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        addSubview(resultLabel) {
            $0.trailing.top.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }

    func setup(with count: Int) {
        resultLabel.text = "\(count) results in favourites"
    }
}
