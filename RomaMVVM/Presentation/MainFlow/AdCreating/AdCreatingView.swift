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
    private var lineView = UIView()
    private var stackView = UIStackView()
    private var backButton = UIButton()
    private var forwardButton = UIButton()
    private var collectionView: UICollectionView!

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdCreatingViewAction, Never>()

    let layout = UICollectionViewFlowLayout()
    let dataSourse = AdCollectionDataSource() //: [AdCollectionModel] = [.address, .propertyType, .year, .photo]

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        setupLayout()
        setupUI()
        setupCollectionView()
        bindActions()
    }

    private func bindActions() {}

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = dataSourse
        collectionView.register(AddressCell.self)
        collectionView.register(PropertyTypeCell.self)
        collectionView.register(YearCell.self)
        collectionView.register(PictureCell.self)
        collectionView.backgroundColor = .red
        layout.scrollDirection = .horizontal
    }

    private func setupUI() {
        backgroundColor = .white

        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.tintColor = .red
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .orange

        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "multiply",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        crossButton.configuration = config
        crossButton.imageView?.clipsToBounds = true
        crossButton.tintColor = .gray
        let action = UIAction { _ in
            self.actionSubject.send(.crossDidTap)
        }
        crossButton.addAction(action, for: .touchUpInside)

        lineView.backgroundColor = .gray

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.distribution = .fillEqually

        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.titleLabel?.textAlignment = .center
        backButton.layer.cornerRadius = 3
        backButton.bordered(width: 2, color: .gray)

        forwardButton.backgroundColor = .orange
        forwardButton.setTitle("Forward", for: .normal)
        forwardButton.setTitleColor(.black, for: .normal)
        forwardButton.titleLabel?.textAlignment = .center
        forwardButton.layer.cornerRadius = 3
        forwardButton.bordered(width: 2, color: .gray)
    }

    private func setupLayout() {
        addSubview(pageControl) {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(70)
            $0.height.equalTo(20)
            $0.width.equalTo(200)
        }
        addSubview(crossButton) {
            $0.centerY.equalTo(pageControl.snp.centerY)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(100)
        }
        addSubview(collectionView) {
            $0.top.equalTo(pageControl.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        addSubview(lineView) {
            $0.top.equalTo(collectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        addSubview(stackView) {
            $0.top.equalTo(lineView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(100)
        }
        backButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        forwardButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        stackView.addArrangedSubviews([backButton, forwardButton])
    }
}

// MARK: - UICollectionViewDataSource
extension AdCreatingView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if collectionView == collectionView {
            if pageControl.currentPage == indexPath.section {
                guard let visible = collectionView.visibleCells.first else {
                    return
                }
                guard let index = collectionView.indexPath(for: visible)?.section else {
                    return
                }
                pageControl.currentPage = index
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AdCreatingView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
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
