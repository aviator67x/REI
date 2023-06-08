//
//  LorenIpsumView.swift
//  RomaMVVM
//
//  Created by User on 07.06.2023.
//

import Combine
import UIKit

enum LoremIpsumViewAction {
}

final class LoremIpsumView: BaseView {
    // MARK: - Subviews
    private let ipsumLabel = UILabel()
    private let blueprintImageView = UIImageView()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<LoremIpsumViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        setupUI()
        bindActions()
    }

    private func bindActions() {}

    private func setupUI() {
        backgroundColor = .white

        ipsumLabel.font = UIFont.systemFont(ofSize: 18)
        ipsumLabel.numberOfLines = 0
        ipsumLabel.text = Constant.ipsumText.rawValue

        blueprintImageView.image = UIImage(named: "blueprint")
    }

    func setupLayout(state: LoremState) {
        switch state {
        case .text:
            addSubview(ipsumLabel) {
                $0.center.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.height.equalTo(400)
            }
        case .blueprint:
            addSubview(blueprintImageView) {
                $0.center.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.height.equalTo(400)
            }
        }
    }
}

// MARK: - View constants
private enum Constant: String {
    case ipsumText = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    """
}

#if DEBUG
    import SwiftUI
    struct LorenIpsumPreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(LoremIpsumView())
        }
    }
#endif
