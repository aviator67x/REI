//
//  HouseImagesViewController.swift
//  RomaMVVM
//
//  Created by User on 06.06.2023.
//

import UIKit

final class HouseImagesViewController: BaseViewController<HouseImagesViewModel> {
    // MARK: - Views
    private let contentView = HouseImagesView()
    private let pageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    private let button = CrossButton()

    private var total = 0

    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = .white

        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance

        button.addTarget(self, action: #selector(pop), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)

        pageLabel.font = UIFont.systemFont(ofSize: 16)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: pageLabel)
    }

    @objc func pop() {
        viewModel.popScreen()
    }

    private func setupLabel(current: Int, total: Int) {
        pageLabel.text = "\(current)/\(total)"
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case let .current(page: page):
                    self.setupLabel(current: page, total: total)
                }
            }
            .store(in: &cancellables)

        viewModel.sectionsPublisher
            .sinkWeakly(self, receiveValue: { (self, sections) in
                self.contentView.setupSnapshot(sections: sections)
                self.total = sections[0].items.count
            })
            .store(in: &cancellables)
    }
}
