//
//  SelectView.swift
//  RomaMVVM
//
//  Created by User on 21.04.2023.
//

import Foundation
import UIKit
import Combine

enum SelectViewAction {
    case find
    case sort
    case favourite
}

final class SelectView: UIView {
    private let stackView = UIStackView()
    private lazy var findButton = UIButton()
    private lazy var sortButton = UIButton()
    private lazy var favouriteButton = UIButton()
    
    private var cancellables = Set<AnyCancellable>()
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private lazy var actionSubject = PassthroughSubject<SelectViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupBinding()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        findButton.setTitle("\u{1F50D} Find", for: .normal)
        sortButton.setTitle("\u{2550} Sort", for: .normal)
        favouriteButton.setTitle("\u{1F514} Favourite", for: .normal)
        [findButton, sortButton, favouriteButton].forEach { button in
            button.setTitleColor(.systemBlue, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            button.backgroundColor = .lightGray
            button.bordered(width: 1, color: .gray)
        }
    }

    private func setupLayout() {
        addSubview(stackView) {
            $0.edges.equalToSuperview()
            $0.height.equalTo(60)
        }
        stackView.addArrangedSubviews([findButton, sortButton, favouriteButton])
    }
    
    private func setupBinding() {
        findButton.tapPublisher
            .sink { _ in
                self.actionSubject.send(.find)
            }
            .store(in: &cancellables)
        
        favouriteButton.tapPublisher
            .sink { _ in
                self.actionSubject.send(.sort)
            }
            .store(in: &cancellables)
        
        favouriteButton.tapPublisher
            .sink { _ in
                self.actionSubject.send(.favourite)
            }
            .store(in: &cancellables)
    }
}
