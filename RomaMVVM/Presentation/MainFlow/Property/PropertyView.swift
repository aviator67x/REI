//
//  PropertyView.swift
//  RomaMVVM
//
//  Created by User on 06.03.2023.
//

import Combine
import Kingfisher
import UIKit

enum PropertyViewAction {
    case filterDidTap
}

final class PropertyView: BaseView {
    // MARK: - Subviews

    private let pickerView = UIPickerView()
    private let imageView = UIImageView()
    private let idLabel = UILabel()
    private let filterButton = BaseButton(buttonState: .filter)

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<PropertyViewAction, Never>()
    
    private let propertyColumns = PropertyColumn.allCases
    var index0 = 0
    var index1 = 1

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
//        setImage()
    }

    private func bindActions() {
        filterButton.tapPublisher
            .sink { [unowned self] in
                actionSubject.send(.filterDidTap)
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
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(200)
        }
        addSubview(idLabel) {
            $0.top.equalTo(pickerView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        addSubview(imageView) {
            $0.top.equalTo(idLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(300)
        }
        addSubview(filterButton) {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }

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

// MARK: - View constants
private enum Constant {}

extension PropertyView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return propertyColumns.count
        } else {
            switch index0 {
            case 0:
                return PropertyColumn.Layout.allCases.count
            case 1:
                return PropertyColumn.PropertyType.allCases.count
              
            case 2:
                return PropertyColumn.RealEstateCategoty.allCases.count
            case 3: return  PropertyColumn.ResidenceType.allCases.count
            case 4: return PropertyColumn.SaleOrRent.allCases.count
            default: return 1
            }
        }
    }
}

extension PropertyView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let name = PropertyColumn.Layout.allCases[index1].rawValue
        if component == 0 {
            return propertyColumns[index0].rawValue
        } else {
            return name
            guard index1 < 4 else { return "Out of range"}
            switch index0 {
            case 0:
                return PropertyColumn.Layout.allCases[index1].rawValue
            case 1:
                return PropertyColumn.PropertyType.allCases[index1].rawValue
              
            case 2:
                return PropertyColumn.RealEstateCategoty.allCases[index1].rawValue
            case 3: return  PropertyColumn.ResidenceType.allCases[index1].rawValue 
            default: return "Out of range"
            }
//            return PropertyColumn.PropertyType.allCases[index].rawValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        index0 = pickerView.selectedRow(inComponent: 0)
        pickerView.reloadComponent(1)
        pickerView.reloadComponent(0)
        index1 = pickerView.selectedRow(inComponent: 1)
    }
}

