//
//  PasswordRestoreView.swift
//  RomaMVVM
//
//  Created by User on 27.02.2023.
//

import UIKit
import Combine

enum PasswordRestoreViewAction {
    case restoreDidTap
    case emailTextFieldDidChange(inputText: String)
}

final class PasswordRestoreView: BaseView {
    // MARK: - Subviews


    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<PasswordRestoreViewAction, Never>()
    
    private let restorePasswordButton = BaseButton(buttonState: .restorePassword)
    private let emailTextField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }

    private func bindActions() {
        restorePasswordButton.tapPublisher
            .sink { [unowned self] in
                actionSubject.send(.restoreDidTap)
            }
            .store(in: &cancellables)
        
        emailTextField.textPublisher
            .sink { [unowned self] text in
                actionSubject.send(.emailTextFieldDidChange(inputText: text ?? ""))
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .white
        emailTextField.text = "aviator67x@gmail.com"
        emailTextField.textAlignment = .center
        emailTextField.borderStyle = .roundedRect
        emailTextField.layer.borderWidth = 1
    }

    private func setupLayout() {
        addSubview(restorePasswordButton) {_ in
            restorePasswordButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            restorePasswordButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            restorePasswordButton.widthAnchor.constraint(equalToConstant: 350).isActive = true
            restorePasswordButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            addSubview(emailTextField)
            emailTextField.translatesAutoresizingMaskIntoConstraints = false
            emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
            emailTextField.widthAnchor.constraint(equalToConstant: 350).isActive = true
            emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            emailTextField.centerYAnchor.constraint(equalTo: restorePasswordButton.centerYAnchor, constant: 100).isActive = true
        }
    }
}

// MARK: - View constants
private enum Constant {
}

#if DEBUG
import SwiftUI
struct PasswordRestorePreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(PasswordRestoreView())
    }
}
#endif
