//
//  MainTabBarViewController.swift
//  REI
//
//  Created by user on 28.11.2023.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    
    private var viewModel: MainTabBarViewModel

    // MARK: - Life cycle
    init(viewModel: MainTabBarViewModel, viewControllers: [UIViewController]) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers?.enumerated().reversed().forEach({ [unowned self] (ind, _) in
            selectedIndex = ind
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}
