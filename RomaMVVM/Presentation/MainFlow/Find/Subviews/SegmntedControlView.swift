//
//  SegmntedControlView.swift
//  RomaMVVM
//
//  Created by User on 21.04.2023.
//

import Foundation
import UIKit

final class SegmentedControlView: UIView {
    private let segmentControl = UISegmentedControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        segmentControl.backgroundColor = .orange
        segmentControl.insertSegment(withTitle: "Foto", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "List", at: 1, animated: true)
        segmentControl.insertSegment(withTitle: "Map", at: 2, animated: true)
        segmentControl.sizeToFit()
        segmentControl.selectedSegmentIndex = 0
        segmentControl.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)],
            for: .normal
        )
    }
    
    private func setupLayout() {
        addSubview(segmentControl) {
            $0.edges.equalToSuperview()
            $0.height.equalTo(25)
        }
    }
}
