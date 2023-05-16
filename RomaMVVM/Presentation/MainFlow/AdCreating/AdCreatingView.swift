//
//  AdCreatingView.swift
//  RomaMVVM
//
//  Created by User on 15.05.2023.
//

import Combine
import UIKit

enum AdCreatingViewAction {
    case crossDidTap
}

final class AdCreatingView: BaseView {
    // MARK: - Subviews
    private var pageControl = UIPageControl()
    private var crossButton = UIButton()
    private var collectionView: UICollectionView!
    private var backButton = UIButton()
    private var forwardButton = UIButton()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdCreatingViewAction, Never>()

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
    }

    private func bindActions() {}

    private func setupUI() {
        backgroundColor = .white

        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.tintColor = .red
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .orange
    
        crossButton.setImage(UIImage(systemName: "multiply"), for: .normal)
        crossButton.frame = CGRectMake(0, 0, 30, 30)
        let action = UIAction { action in
            self.actionSubject.send(.crossDidTap)
        }
        crossButton.addAction(action, for: .touchUpInside)
                
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.titleLabel?.textAlignment = .center
        backButton.layer.cornerRadius = 3
        
        forwardButton.setTitle("Forward", for: .normal)
        forwardButton.setTitleColor(.orange, for: .normal)
        forwardButton.titleLabel?.textAlignment = .center
        forwardButton.layer.cornerRadius = 3
    }

    private func setupLayout() {
        addSubview(pageControl) {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(30)
            $0.height.equalTo(20)
            $0.width.equalTo(100)
        }
    }
}

// MARK: - View constants
private enum Constant {}

#if DEBUG
    import SwiftUI
    struct AdCreatingPreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(AdCreatingView())
        }
    }
#endif
