//
//  BackgroundHeaderView.swift
//  RomaMVVM
//
//  Created by User on 29.03.2023.
//

import Foundation
import UIKit

final class BackgroundHeaderView: UICollectionReusableView {
    static let identifier = String(describing: BackgroundHeaderView.self)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemTeal
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
