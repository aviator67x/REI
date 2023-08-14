//
//  SwiftUIViewController.swift
//  REI
//
//  Created by User on 14.08.2023.
//

import UIKit

final class SwiftUIViewController: BaseViewController<SwiftUIViewModel> {
    // MARK: - Views
    private let contentView = SwiftUIView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                }
            }
            .store(in: &cancellables)
    }
}
