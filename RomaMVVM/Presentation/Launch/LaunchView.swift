//
//  LaunchView.swift
//  RomaMVVM
//
//  Created by User on 24.02.2023.
//

import UIKit
import Combine

enum LaunchViewAction {

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
        UIView.animate(withDuration: 10) {
            self.logoView.transform = CGAffineTransform(translationX: -80, y: -300)
            self.logoView.transform = self.logoView.transform.scaledBy(x: 0.5, y: 0.5)
        }
//        UIView.animate(withDuration: 5, delay: 1, animations: {
//            self.logoView.transform = CGAffineTransform(translationX: -80, y: -300)
//        }) { _ in
//            self.logoView.transform = self.logoView.transform.scaledBy(x: 0.5, y: 0.5)
//            UIView.animate(withDuration: 5, animations: {
//                self.logoView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//            })
//        }
    }

    private func bindActions() {
    }

    private func setupUI() {
        backgroundColor = .systemBlue
        
        logoView.image = UIImage(named: "logo")
    }

    private func setupLayout() {
        logoView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoView)
        logoView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 128).isActive = true
        logoView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        logoView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
}

// MARK: - View constants
private enum Constant {
}

#if DEBUG
import SwiftUI
struct LaunchPreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(LaunchView())
    }
}
#endif
