//
//  FindViewController.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import UIKit

final class FindViewController: BaseViewController<FindViewModel> {
    
    // MARK: - Views
    private let contentView = FindView()
    private lazy var segmentedControl = SegmentedControl(frame: .zero)
    
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
        self.navigationItem.titleView = segmentedControl
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: UIImage.init(systemName: "face.dashed")))
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .collectionBottomDidReach:
                    viewModel.loadHouses()
                case .collectionTopScrollDidBegin(let offset):
                    viewModel.setSelectViewState(for: offset)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$sections
            .sinkWeakly(self, receiveValue: { (self, sections) in
                self.contentView.setupSnapShot(sections: sections)
            })
            .store(in: &cancellables)
        
        viewModel.$isSelectViewHidden
            .sinkWeakly(self, receiveValue: { (self, value) in
                self.contentView.setupLayout(hideSelect: value)
            })
            .store(in: &cancellables)
        
       segmentedControl.selectedSegmentIndexPublisher
            .sinkWeakly(self, receiveValue: { (self, index) in
                self.viewModel.setScreenState(for: index)
            })
            .store(in: &cancellables)
    }
}
