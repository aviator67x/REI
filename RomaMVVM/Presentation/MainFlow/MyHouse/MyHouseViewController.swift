//
//  MyHouseViewController.swift
//  RomaMVVM
//
//  Created by User on 27.04.2023.
//

import UIKit

final class MyHouseViewController: BaseViewController<MyHouseViewModel> {
    // MARK: - Views
    private let contentView = MyHouseView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MyHouse"
        setupBindings()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create more", style: .plain, target: self, action: #selector(create))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc
    func create() {
        viewModel.moveToNextAd()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .buttonDidTap:
                    viewModel.moveToNextAd()
                case .selectedItem(let item):
                    viewModel.delete(item)
                }
            }
            .store(in: &cancellables)
        
        viewModel.sectionsPublisher
            .sinkWeakly(self, receiveValue: { (self, sections) in
                self.contentView.setupSnapShot(sections: sections)
            })
            .store(in: &cancellables)
    }
}
