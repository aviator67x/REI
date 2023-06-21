//
//  LorenIpsumViewController.swift
//  RomaMVVM
//
//  Created by User on 07.06.2023.
//

import UIKit

final class LoremIpsumViewController: BaseViewController<LoremIpsumViewModel> {
    // MARK: - Views
    private let contentView = LoremIpsumView()
    private let crossButton = CrossButton()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupBindings()
    }
    
    private func setupNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = .white

        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance

        crossButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: crossButton)
    }

    @objc func pop() {
        viewModel.popScreen()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                }
            }
            .store(in: &cancellables)
        
        viewModel.screenStatePublisher
            .sinkWeakly(self, receiveValue: { (self, state) in
                self.contentView.setupLayout(state: state)
            })
            .store(in: &cancellables)
    }
}
