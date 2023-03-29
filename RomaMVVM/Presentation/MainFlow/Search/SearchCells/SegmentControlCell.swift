//
//  SegmentControlCell.swift
//  RomaMVVM
//
//  Created by User on 29.03.2023.
//

import Foundation
import UIKit

final class SegmentControlCell: UICollectionViewCell {
    static let reusedidentifier = String(String(describing: SegmentControlCell.self))

    let segmentControl = UISegmentedControl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemTeal
        setupLayout()
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        segmentControl.backgroundColor = .groupTableViewBackground
        segmentControl.insertSegment(withTitle: "Photo", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "List", at: 1, animated: true)
        segmentControl.insertSegment(withTitle: "Map", at: 2, animated: true)
        segmentControl.sizeToFit()
        segmentControl.selectedSegmentIndex = 0
        segmentControl.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)],
            for: .normal
        )
    }

    private func setupLayout() {
        contentView.addSubview(segmentControl) {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }
}
