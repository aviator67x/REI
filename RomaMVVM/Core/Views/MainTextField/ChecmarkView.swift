//
//  ChecmarkView.swift
//  Interngram-Bravo
//
//  Created by Georhii Kasilov on 30.10.2022.
//

import Foundation
import UIKit

final class CheckmarkView: UIStackView {
    // MARK: - Private properties

    private var text: String

    // MARK: - Lazy properties

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "sfProTextRegular", size: 12)
        label.textColor = UIColor(named: "lightSecondaryText")
        return label
    }()

    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "checkmark")
        imageView.isHidden = true

        return imageView
    }()

    // MARK: - Life cycle

    init(text: String) {
        self.text = text
        super.init(frame: .zero)
        axis = .horizontal
        alignment = .center
        spacing = 4.67
        addArrangedSubview(label)
        addArrangedSubview(checkmarkImageView)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func setValid(_ isValid: Bool) {
        checkmarkImageView.isHidden = !isValid
        label.textColor = isValid ? UIColor(named: "secondaryTextColor") : UIColor(named: "lightSecondaryTextColor")
    }
}
