//
//  YearCell.swift
//  RomaMVVM
//
//  Created by User on 03.04.2023.
//

import Foundation
import UIKit

final class DetailedCell: UICollectionViewCell {
    static let identifier = "YearCell"
    private let titleLable = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        titleLable.bordered(width: 1, color: .black)
        titleLable.layer.cornerRadius = 3
        titleLable.font = UIFont.systemFont(ofSize: 18)
        titleLable.baselineAdjustment = .alignCenters
        titleLable.textAlignment = .center
    }

    private func setupLayout() {
        contentView.addSubview(titleLable) {
            $0.top.bottom.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }

    func setupCell(yearTitle: PeriodOfBuilding) {
            titleLable.text = String(yearTitle.rawValue)
    }
    
    func setupCell(garageTitle: Garage) {
            titleLable.text = String(garageTitle.rawValue)
    }
    
    func setupCell(numberTitle: NumberOfRooms) {
            titleLable.text = String(numberTitle.rawValue)
    }
    
    func setupCell(typeTitle: PropertyType) {
            titleLable.text = String(typeTitle.rawValue)
    }
}

  
