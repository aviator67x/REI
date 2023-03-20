//
//  PasswordView.swift
//  RomaMVVM
//
//  Created by User on 20.03.2023.
//

import UIKit
import Combine

enum PasswordViewAction {

}

final class PasswordView: BaseView {
    // MARK: - Subviews


    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<PasswordViewAction, Never>()

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
    }

    private func setupUI() {
        backgroundColor = .white
    }

    private func setupLayout() {
    }
}

// MARK: - View constants
private enum Constant {
}

#if DEBUG
import SwiftUI
struct PasswordPreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(PasswordView())
    }
}
#endif
