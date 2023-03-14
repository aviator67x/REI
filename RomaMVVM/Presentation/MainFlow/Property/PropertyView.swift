//
//  PropertyView.swift
//  RomaMVVM
//
//  Created by User on 06.03.2023.
//

import Combine
import Kingfisher
import UIKit
import Foundation

enum PropertyViewAction {
    case searchDidTap
    case pickerKeyDidChose(key: PropertyColumn)
    case pickerValueDidChose(value: SearchType)
}

final class PropertyView: BaseView {
    
    // MARK: - Subviews
    private let pickerView = UIPickerView()
    private let imageView = UIImageView()
    private let idLabel = UILabel()
    private let searchButton = BaseButton(buttonState: .filter)
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<PropertyViewAction, Never>()
    
    private let propertyColumns = PropertyColumn.allCases
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
        pickerView.delegate = self
    }
    
    private func bindActions() {
        searchButton.tapPublisher
            .sink { [unowned self] in
                actionSubject.send(.searchDidTap)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        backgroundColor = .white
        pickerView.backgroundColor = .red
        idLabel.textAlignment = .center
        idLabel.text = "Text of idLabel"
        idLabel.backgroundColor = .yellow
        imageView.backgroundColor = .cyan
    }
    
    private func setupLayout() {
        addSubview(pickerView) {
            $0.top.equalToSuperview().offset(100)
            $0.leading.trailing.equalToSuperview().inset(Constants.inset)
            $0.height.equalTo(200)
        }
        addSubview(idLabel) {
            $0.top.equalTo(pickerView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(Constants.inset)
            $0.height.equalTo(Constants.height)
        }
        addSubview(imageView) {
            $0.top.equalTo(idLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(Constants.inset)
            $0.height.equalTo(300)
        }
        addSubview(searchButton) {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(Constants.inset)
            $0.height.equalTo(Constants.height)
        }
    }
    
    // MARK: - View constants
    private enum Constants {
        static let inset: CGFloat = 16
        static let height: CGFloat = 50
    }
}
    // MARK: - extension
    extension PropertyView {
    func setImage() {
        let url =
            URL(
                string: "https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png"
            )
        imageView.kf.setImage(with: url, options: [.forceRefresh]) { respose in
            switch respose {
            case let .success(data):
                print(data)
            case let .failure(error):
                print(error.errorDescription ?? "")
            }
        }

        imageView.backgroundColor = .cyan
    }

    func setLabel(id: String) {
        idLabel.text = id
    }
}


// MARK: - extension UIPickerViewDataSource
extension PropertyView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return propertyColumns.count
        } else {
            let propertyColumnIndex = pickerView.selectedRow(inComponent: 0)

            guard let propertyColumn = propertyColumns[safe: propertyColumnIndex] else { return 0 }

            switch propertyColumn {
            case .layout:
                return PropertyColumn.Layout.allCases.count
            case .propertyType:
                return PropertyColumn.PropertyType.allCases.count

            case .realEstateCategory:
                return PropertyColumn.RealEstateCategoty.allCases.count

            case .residenceType:
                return PropertyColumn.ResidenceType.allCases.count
            case .saleOrRent:
                return PropertyColumn.SaleOrRent.allCases.count
            }
        }
    }
}

// MARK: - extension UIPickerViewDelegate
extension PropertyView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
        if component == 0 {
            return propertyColumns[safe: row]?.rawValue
        } else {
            let propertyColumnIndex = pickerView.selectedRow(inComponent: 0)

            guard let propertyColumn = propertyColumns[safe: propertyColumnIndex] else { return nil }

            switch propertyColumn {
            case .layout:
                return PropertyColumn.Layout.allCases[safe: row]?.rawValue
            case .propertyType:
                return PropertyColumn.PropertyType.allCases[safe: row]?.rawValue

            case .realEstateCategory:
                return PropertyColumn.RealEstateCategoty.allCases[safe: row]?.rawValue

            case .residenceType:
                return PropertyColumn.ResidenceType.allCases[safe: row]?.rawValue
            case .saleOrRent:
                return PropertyColumn.SaleOrRent.allCases[safe: row]?.rawValue
            }
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        switch component {
        case 0:
            actionSubject.send(.pickerKeyDidChose(key: propertyColumns[row]))
            pickerView.reloadComponent(1)
        case 1:
            let propertyColumn = propertyColumns[pickerView.selectedRow(inComponent: 0)]
            switch propertyColumn {
            case .layout:
                actionSubject.send(.pickerValueDidChose(value: .equalToString(parameter: PropertyColumn.Layout.allCases[row].rawValue)))
            case .propertyType:
                actionSubject.send(.pickerValueDidChose(value: .equalToString(parameter: PropertyColumn.PropertyType.allCases[row].rawValue)))
            case .realEstateCategory:
                actionSubject.send(.pickerValueDidChose(value: .equalToString(parameter: PropertyColumn.RealEstateCategoty.allCases[row].rawValue)))
            case .residenceType:
                actionSubject.send(.pickerValueDidChose(value: .equalToString(parameter: PropertyColumn.ResidenceType.allCases[row].rawValue)))
            case .saleOrRent:
                actionSubject.send(.pickerValueDidChose(value: .equalToString(parameter: PropertyColumn.SaleOrRent.allCases[row].rawValue)))
            }
           
        default: return
        }
    }
}
