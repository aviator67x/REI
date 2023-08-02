//
//  LivingAreaPickerCell.swift
//  REI
//
//  Created by User on 27.05.2023.
//

import Combine
import Foundation
import UIKit

enum LivingAreaCellCellAction {
    case livingArea(Int)
}

final class LivingAreaCell: UICollectionViewCell {
    lazy var cancellables = Set<AnyCancellable>()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<LivingAreaCellCellAction, Never>()

    private let sliderView = UISlider()
    private let sliderLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBinding() {}

    private func setupUI() {        
        sliderView.backgroundColor = .secondarySystemBackground
        sliderView.minimumValue = 20
        sliderView.maximumValue = 200
        sliderView.value = 110
        sliderView.isContinuous = true // false
        let finishedAction = UIAction { action in
            let slider = action.sender as! UISlider
            let value = slider.value
            self.actionSubject.send(.livingArea(Int(value)))
        }
        let action = UIAction { action in
            let slider = action.sender as! UISlider
            let value = slider.value

//            slider.value = roundf(slider.value)

//            let trackRect = slider.trackRect(forBounds: slider.frame)
//            let thumbRect = slider.thumbRect(forBounds: slider.bounds, trackRect: trackRect, value: slider.value)
//            self.sliderLabel.center = CGPoint(x: thumbRect.midX, y: thumbRect.midY + 50)
            self.sliderLabel.text = String(format: "%.0f", value)
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
        sliderView.addAction(action, for: .valueChanged)
        sliderView.addAction(finishedAction, for: .touchUpInside)
        
        sliderLabel.text = String(format: "%.0f", sliderView.value)
        sliderLabel.textAlignment = .center
    }

    private func setupLayout() {
        contentView.addSubview(sliderView) {
            $0.edges.equalToSuperview()
            $0.height.equalTo(300)
        }

        contentView.addSubview(sliderLabel) {
            $0.size.equalTo(40)
            $0.centerX.equalTo(sliderView.snp.centerX)
            $0.centerY.equalTo(sliderView.snp.centerY).offset(50)
        }
    }
}
