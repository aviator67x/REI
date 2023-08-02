//
//  YearPickerCell.swift
//  REI
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

    private let pickerView = UIPickerView()
    private var dataSource: [String] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupDataSource()
        setupLayout()
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBinding() {}

    private func setupUI() {
        pickerView.backgroundColor = .systemGroupedBackground
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(2000, inComponent: 0, animated: true)
    }

    private func setupLayout() {
        contentView.addSubview(pickerView) {
            $0.edges.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
    
    private func setupDataSource() {
        let range = Array(1800...2023)
        range.map {String($0)}
            .forEach { year in
            dataSource.append(year)
        }
    }
}

// MARK: - UIPickerViewDataSource
extension YearPickerCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
}

// MARK: - UIPickerViewDelegate
extension YearPickerCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let year = Int(dataSource[row]) else {
            return
        }
        actionSubject.send(.yearPicker(year))
    }
}

