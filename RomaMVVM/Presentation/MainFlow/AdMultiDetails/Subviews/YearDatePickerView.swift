//
//  YearDatePicker.swift
//  RomaMVVM
//
//  Created by User on 23.05.2023.
//

import Foundation
import UIKit
import Combine

enum YearDatePickerViewAction {
    case yearPicker(String)
}

final class YearDatePickerView: UIView {
    private var pickerView = UIPickerView()
    private var dataSource: [String] = []
    
    private(set) lazy var selectedYearPublisher = selectedYearSubject.eraseToAnyPublisher()
    private lazy var selectedYearSubject = PassthroughSubject<Int, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupDataSource()
        setupaLayout()
        setupDatePicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDatePicker() {
        pickerView.backgroundColor = .systemGroupedBackground
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(220, inComponent: 0, animated: false)
    }
    
    private func setupaLayout() {
        addSubview(pickerView) {
            $0.edges.equalToSuperview()
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
extension YearDatePickerView: UIPickerViewDataSource {
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
extension YearDatePickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let year = Int(dataSource[row]) else {
            return
        }
        selectedYearSubject.send(year)
    }
}
