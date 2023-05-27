//
//  AdDetailsView.swift
//  RomaMVVM
//
//  Created by User on 22.05.2023.
//

import Combine
import UIKit

enum AdDetailsViewAction {
    case crossDidTap
    case onBackTap
    case onForwardTap
    case onTypeTap
    case onNumberTap
    case onYearTap
    case onGarageTap
}

final class AdDetailsView: BaseView {
    // MARK: - Subviews
    private var pageControl = UIPageControl()
    private var crossButton = UIButton()
    private let addressLabel = UILabel()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private let typeButton = UIButton()
    private let numberButton = UIButton()
    private let yearButton = UIButton()
    private let garageButton = UIButton()
    private var lineView = UIView()
    private var buttonStackView = UIStackView()
    private var backButton = UIButton()
    private var forwardButton = UIButton()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdDetailsViewAction, Never>()

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
    }

    private func bindActions() {
        crossButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.crossDidTap)
            })
            .store(in: &cancellables)

        backButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.onBackTap)
            })
            .store(in: &cancellables)

        forwardButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.onForwardTap)
            })
            .store(in: &cancellables)

        typeButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.onTypeTap)
            })
            .store(in: &cancellables)

        numberButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.onNumberTap)
            })
            .store(in: &cancellables)

        yearButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.onYearTap)
            })
            .store(in: &cancellables)

        garageButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.onGarageTap)
            })
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .white

        pageControl.numberOfPages = 3
        pageControl.currentPage = 1
        pageControl.tintColor = .red
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .orange
        addressLabel.text = "Kharkiv Khreschatik 21"
        addressLabel.font = UIFont.systemFont(ofSize: 20)

        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "multiply",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        crossButton.configuration = config
        crossButton.imageView?.clipsToBounds = true
        crossButton.tintColor = .gray

        titleLabel.text = "What about other details?"
        titleLabel.font = UIFont.systemFont(ofSize: 32)
        titleLabel.numberOfLines = 0

        typeButton.setTitle("Type of property", for: .normal)
        numberButton.setTitle("Number of rooms", for: .normal)
        garageButton.setTitle("Type of parking", for: .normal)
        yearButton.setTitle("Year of construction", for: .normal)

        [typeButton, numberButton, yearButton, garageButton].forEach { button in
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.textAlignment = .left
            button.layer.cornerRadius = 3
            button.bordered(width: 2, color: .gray)
        }

        stackView.axis = .vertical
        stackView.spacing = 10

        lineView.backgroundColor = .gray

        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .center
        buttonStackView.spacing = 16
        buttonStackView.distribution = .fillEqually

        [backButton, forwardButton].forEach { button in
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.layer.cornerRadius = 3
            button.bordered(width: 2, color: .gray)
        }
        backButton.setTitle("Back", for: .normal)

        forwardButton.backgroundColor = .orange
        forwardButton.setTitle("Forward", for: .normal)
    }

    private func setupLayout() {
        addSubview(pageControl) {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(70)
            $0.height.equalTo(20)
            $0.width.equalTo(200)
        }
        addSubview(crossButton) {
            $0.centerY.equalTo(pageControl.snp.centerY)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(40)
        }

        addSubview(addressLabel) {
            $0.top.equalTo(crossButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        addSubview(titleLabel) {
            $0.top.equalTo(addressLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        addSubview(stackView) {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        [typeButton, numberButton, yearButton, garageButton]
            .forEach { button in button.snp.makeConstraints {
                $0.height.equalTo(50)
            }
            }

        stackView.addArrangedSubviews([typeButton, numberButton, yearButton, garageButton])

        addSubview(buttonStackView) {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(100)
        }

        backButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }

        forwardButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        buttonStackView.addArrangedSubviews([backButton, forwardButton])

        addSubview(lineView) {
            $0.bottom.equalTo(buttonStackView.snp.top).offset(-20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
}

// MARK: - View constants
private enum Constant {}

#if DEBUG
    import SwiftUI
    struct AdDetailsPreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(AdDetailsView())
        }
    }
#endif
