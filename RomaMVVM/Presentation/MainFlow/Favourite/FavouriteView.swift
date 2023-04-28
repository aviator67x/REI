//
//  FavouriteView.swift
//  RomaMVVM
//
//  Created by User on 27.04.2023.
//

import UIKit
import Combine

enum FavouriteViewAction {

}

final class FavouriteView: BaseView {
    // MARK: - Subviews


    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<FavouriteViewAction, Never>()

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
struct FavouritePreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(FavouriteView())
    }
}
#endif
