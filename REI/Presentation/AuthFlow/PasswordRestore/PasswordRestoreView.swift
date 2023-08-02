//
//  PasswordRestoreView.swift
//  REI
//
//  Created by User on 27.02.2023.
//

import Combine
import UIKit

enum PasswordRestoreViewAction {
    case restoreDidTap
    case emailTextFieldDidChange(inputText: String)
    case crossDidTap
}

final class PasswordRestoreView: BaseView {
    // MARK: - Subviews

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<PasswordRestoreViewAction, Never>()

    private let restorePasswordButton = BaseButton(buttonState: .restorePassword)
    private let emailTextField = UITextField()
    private let crossButton = UIButton()

    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    @objc
    private func hideKeyboardByTappingOutside() {
        endEditing(true)
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardByTappingOutside))
        addGestureRecognizer(tap)
    }

    private func bindActions() {
        restorePasswordButton.tapPublisher
            .sink { [unowned self] in
                actionSubject.send(.restoreDidTap)
            }
            .store(in: &cancellables)

        emailTextField.textPublisher
            .sink { [unowned self] text in
                guard let text = text else {
                    return
                }
                actionSubject.send(.emailTextFieldDidChange(inputText: text))
            }
            .store(in: &cancellables)

        crossButton.tapPublisher
            .sink { [unowned self] _ in
                actionSubject.send(.crossDidTap)
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .systemGray
        emailTextField.placeholder = "Email"
        emailTextField.textAlignment = .center
        emailTextField.borderStyle = .roundedRect
        emailTextField.layer.borderWidth = 1

        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "multiply",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        crossButton.configuration = config
        crossButton.imageView?.clipsToBounds = true
        crossButton.tintColor = .white

        restorePasswordButton.backgroundColor = .orange
    }

    private func setupLayout() {
        addSubview(crossButton) {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(50)
            $0.size.equalTo(40)
        }

        addSubview(emailTextField) {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }

        addSubview(restorePasswordButton) {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-120)
        }
    }
}

// MARK: - Internal extension
extension PasswordRestoreView {
    func updateRestoreButton(_ value: Bool) {
        restorePasswordButton.alpha = value ? 1 : 0.5
    }
}

// MARK: - View constants
private enum Constant {}

#if DEBUG
    import SwiftUI
    struct PasswordRestorePreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(PasswordRestoreView())
        }
    }
#endif
