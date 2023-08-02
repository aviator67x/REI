//
//  SegmentControlCell.swift
//  REI
//
//  Created by User on 29.03.2023.
//

import Foundation
import UIKit
import Combine

final class SegmentControlCell: UICollectionViewCell {
    static let reusedidentifier = String(String(describing: SegmentControlCell.self))

    private let segmentControl = UISegmentedControl()
    
    private var cancellables = Set<AnyCancellable>()
    
    private(set) lazy var segmentPublisher = segmentSubject.eraseToAnyPublisher()
    private lazy var segmentSubject = CurrentValueSubject<Int?, Never>(nil)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemTeal
        setupLayout()
        setupUI()
        setupBinding()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBinding() {
        segmentControl.selectedSegmentIndexPublisher
            .sinkWeakly(self, receiveValue: { (self, value) in
                self.segmentSubject.value = value
            })
            .store(in: &cancellables)
    }

    private func setupUI() {
        segmentControl.backgroundColor = .systemBackground
        segmentControl.insertSegment(withTitle: "Buy", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "Rent", at: 1, animated: true)
        segmentControl.insertSegment(withTitle: "New built", at: 2, animated: true)
        segmentControl.sizeToFit()
        segmentControl.selectedSegmentIndex = 0
        segmentControl.setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)],
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
