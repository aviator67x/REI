//
//  HomeView.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 14.12.2021.
//

import Combine
import UIKit

enum HomeViewAction {
  
}

final class HomeView: BaseView {
    // MARK: - Subviews
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let tokenLabel = UILabel()
    private let idLabel = UILabel()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<HomeViewAction, Never>()

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
           
    }

    private func setupUI() {
        backgroundColor = .lightGray
        let labels = [nameLabel, emailLabel, tokenLabel, idLabel]
        labels.forEach { label in
            label.backgroundColor = .yellow
            label.bordered(width: 1, color: .red)
        }
    }

    private func setupLayout() {
        let stack = UIStackView()
        stack.setup(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 8)
        stack.addCentered(nameLabel, inset: 16, size: 50)
        stack.addCentered(emailLabel, inset: 16, size: 50)
        stack.addCentered(tokenLabel, inset: 16, size: 50)
        stack.addCentered(idLabel, inset: 16, size: 50)
        addSubview(stack, withEdgeInsets: UIEdgeInsets(top: 100, left: 0, bottom: 350, right: 0), safeArea: true)
    }

    func updateUser(_ user: UserModel) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        tokenLabel.text = user.accessToken
        idLabel.text = user.accessToken
    }
}

// MARK: - View constants
private enum Constant {
   
}


