//
//  SegmntedControlView.swift
//  REI
//
//  Created by User on 21.04.2023.
//

import Foundation
import UIKit

final class SegmentedControl: UISegmentedControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .orange
        insertSegment(withTitle: "Photo", at: 0, animated: true)
        insertSegment(withTitle: "List", at: 1, animated: true)
        insertSegment(withTitle: "Map", at: 2, animated: true)
        sizeToFit()
        selectedSegmentIndex = 0
        setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)],
            for: .normal
        )
    }
}
