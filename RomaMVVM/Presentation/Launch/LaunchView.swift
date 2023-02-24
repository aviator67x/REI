//
//  LaunchView.swift
//  RomaMVVM
//
//  Created by User on 24.02.2023.
//

import Combine
import UIKit

enum LaunchViewAction {
    case animationDidFinish
}

final class LaunchView: BaseView {
    // MARK: - Subviews
    private let logoView = UIImageView()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<LaunchViewAction, Never>()

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
        animateLogo()
    }

    private func animateLogo() {
        let originalTransform = logoView.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.5, y: 0.5)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: -UIScreen.main.bounds.width/1.5, y: -UIScreen.main.bounds.height/1.5)
        UIView.animate(withDuration: 2, delay: 1, animations: {
            self.logoView.transform = scaledAndTranslatedTransform
        }) {
            _ in //self.actionSubject.send(.animationDidFinish)
        }
    }

    private func bindActions() {}

    private func setupUI() {
        backgroundColor = .systemBlue

        logoView.image = UIImage(named: "logo")
    }

    private func setupLayout() {
        logoView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoView)
        logoView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 128).isActive = true
        logoView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

// MARK: - View constants
private enum Constant {}

#if DEBUG
    import SwiftUI
    struct LaunchPreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(LaunchView())
        }
    }
#endif
