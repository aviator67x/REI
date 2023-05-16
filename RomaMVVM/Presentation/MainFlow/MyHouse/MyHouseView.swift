//
//  MyHouseView.swift
//  RomaMVVM
//
//  Created by User on 27.04.2023.
//

import Combine
import UIKit

enum MyHouseViewAction {
    case buttonDidTap
}

final class MyHouseView: BaseView {
    // MARK: - Subviews
    private let imageView = UIImageView()
    private let questionLabel = UILabel()
    private let textLabel = UILabel()
    private let button = UIButton()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MyHouseViewAction, Never>()

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
        button.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.buttonDidTap)
            })
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .white
        imageView.image = UIImage(named: "house")
        imageView.rounded(50)

        let quote = "Want to know the market price of your property?"
        let text = "Add the house to your accout and get updated about the current value of your property"
        questionLabel.text = quote
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)

        textLabel.text = text
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 18)

        button.backgroundColor = .systemBlue
        button.setTitle("Create an advertisement", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 3
    }

    private func setupLayout() {
        addSubview(imageView) {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(250)
            $0.size.equalTo(100)
        }
        addSubview(questionLabel) {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        addSubview(textLabel) {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(questionLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        addSubview(button) {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(textLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
}

// MARK: - View constants
private enum Constant {}

#if DEBUG
    import SwiftUI
    struct MyHousePreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(MyHouseView())
        }
    }
#endif
