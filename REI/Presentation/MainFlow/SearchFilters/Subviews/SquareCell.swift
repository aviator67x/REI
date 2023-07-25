//
//  SquareCell.swift
//  RomaMVVM
//
//  Created by User on 29.03.2023.
//

import Foundation
import UIKit
import Combine

final class SquareCell: UICollectionViewListCell {   
    private let stack = UIStackView()
    private let minTextField = TextField()
    private let maxTextField = TextField()
    private let middleLabel = UILabel()
    
    private var minSquare = 0
    private var maxSquare = 0
    
    private var cancellables = Set<AnyCancellable>()

    var minValue: ((String) -> ())?
    var maxValue: ((String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupUI()
        addPadding()
        setupBinding()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables = []
    }

    private func setupUI() {
        middleLabel.text = "to:"
        minTextField.placeholder = " 0"
        minTextField.layer.cornerRadius = 3
        minTextField.layer.borderColor = UIColor.lightGray.cgColor
        minTextField.layer.borderWidth = 1
        minTextField.keyboardType = .decimalPad
        minTextField.addDoneButtonOnKeyboard()
        minTextField.delegate = self
        
        maxTextField.placeholder = " Max square"
        maxTextField.layer.cornerRadius = 3
        maxTextField.layer.borderColor = UIColor.lightGray.cgColor
        maxTextField.layer.borderWidth = 1
        maxTextField.keyboardType = .decimalPad
        maxTextField.addDoneButtonOnKeyboard()
        maxTextField.delegate = self
        
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 16
    }
    
    private func addPadding() {
        let maxPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        maxTextField.leftView = maxPaddingView
        maxTextField.leftViewMode = .always
        let minPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        minTextField.leftView = minPaddingView
        minTextField.leftViewMode = .always
    }

    private func setupLayout() {
        contentView.addSubview(stack) {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(23)
            $0.leading.equalToSuperview().offset(35)
        }
        
        minTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalTo(140)
        }
        
        maxTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalTo(140)
        }

        stack.addArrangedSubviews([minTextField, middleLabel, maxTextField])
    }

    private func setupBinding() {}
    
    func setupCell(with model: SquareCellModel) {
        minTextField.text = model.minSquare
        minTextField.textPublisher
            .dropFirst()
            .unwrap()
            .removeDuplicates()
            .sinkWeakly(self, receiveValue: { (self, min) in
                self.minSquare = Int(min) ?? 0
                if self.maxSquare != 0 &&
                    self.minSquare < self.maxSquare || self.maxSquare == 0
                {
                    self.minValue?(min)
                }
            })
            .store(in: &cancellables)
       
        maxTextField.text = model.maxSquare
        maxTextField.textPublisher
            .dropFirst()
            .unwrap()
            .removeDuplicates()
            .sinkWeakly(self, receiveValue: { (self, max) in
                self.maxSquare = Int(max) ?? 0
                if self.minSquare != 0,
                   self.maxSquare < self.minSquare {
                    self.maxValue?(self.minTextField.text ?? "")
                } else {
                    self.maxValue?(max)
                }
            })
            .store(in: &cancellables)
    }
}

extension SquareCell: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        switch textField {
        case minTextField:
            if let text = minTextField.text,
               let textRange = Range(range, in: text),
               maxSquare != 0,
               maxSquare <= minSquare
            {
                minTextField.text = text.replacingCharacters(
                    in: textRange,
                    with: ""
                )
            }
        default:
            break
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case maxTextField:
            if maxSquare <= minSquare {
                maxTextField.text = minTextField.text
            }
           
        default:
            break
        }
    }
}
