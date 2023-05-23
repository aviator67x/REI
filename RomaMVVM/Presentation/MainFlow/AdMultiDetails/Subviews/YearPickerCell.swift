//
//  YearPickerCell.swift
//  RomaMVVM
//
//  Created by User on 23.05.2023.
//

import Combine
import Foundation
import UIKit

enum YearPickerCellAction {
    case yearPicker(Int)
}

final class YearPickerCell: UICollectionViewCell {
    lazy var cancellables = Set<AnyCancellable>()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<YearPickerCellAction, Never>()

    private let pickerView = YearDatePickerView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
        setupUI()
        setupBinding()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBinding() {
        pickerView.selectedYearPublisher
            .sinkWeakly(self, receiveValue: { (self, year) in
                self.actionSubject.send(.yearPicker(year))
            })
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        pickerView.backgroundColor = .red
    }

    private func setupLayout() {
        contentView.addSubview(pickerView) {
            $0.edges.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
}
