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
    case ort(String)
    case street(String)
    case house(String)
    
    case onTypeTap
    case onNumberTap
    case onYearTap
    case onGarageTap
    case onDistanceTap
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

    private let layout = UICollectionViewFlowLayout()
    private let dataSourse = AdCollectionDataSource()
    private var currentPage = 0

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

    private func bindActions() {
        dataSourse.actionPublisher
            .sinkWeakly(self, receiveValue: { (self, value) in
                switch value {
                case .ort(let ort):
                    self.actionSubject.send(.ort(ort))
                case .street(let street):
                    self.actionSubject.send(.street(street))
                case .house(let house):
                    self.actionSubject.send(.house(house))
                case .onTypeTap:
                    self.actionSubject.send(.onTypeTap)
                case .onNumberTap:
                    self.actionSubject.send(.onNumberTap)
                case .onYearTap:
                    self.actionSubject.send(.onYearTap)
                case .onGarageTap:
                    self.actionSubject.send(.onGarageTap)
                case .onDistanceTap:
                    self.actionSubject.send(.onDistanceTap)
                }
            })
            .store(in: &cancellables)
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = dataSourse
        collectionView.register(AddressCell.self)
        collectionView.register(PropertyTypeCell.self)
        collectionView.register(YearCell.self)
        collectionView.register(PictureCell.self)
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
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
        let backdAction = UIAction { _ in
            guard let indexPath = self.collectionView.indexPathsForVisibleItems.first.flatMap({
                IndexPath(row: $0.row, section: $0.section - 1)
            }), indexPath.section >= 0 else {
                return
            }

            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        backButton.addAction(backdAction, for: .touchUpInside)

        forwardButton.backgroundColor = .orange
        forwardButton.setTitle("Forward", for: .normal)
        forwardButton.setTitleColor(.black, for: .normal)
        forwardButton.titleLabel?.textAlignment = .center
        forwardButton.layer.cornerRadius = 3
        forwardButton.bordered(width: 2, color: .gray)
        let forwardAction = UIAction { _ in
            guard let indexPath = self.collectionView.indexPathsForVisibleItems.first.flatMap({
                IndexPath(row: $0.row, section: $0.section + 1)
            }), indexPath.section <= self.dataSourse.dataSource.count - 1 else {
                return
            }

            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        forwardButton.addAction(forwardAction, for: .touchUpInside)
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
            $0.size.equalTo(40)
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
            $0.height.equalTo(44)
        }
        forwardButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        backButton.isHidden = currentPage == 0
        stackView.addArrangedSubviews([backButton, forwardButton])
    }
}

// MARK: - extension
extension AdCreatingView {
    func showValidationLabel(_ model: AddressModel) {
        self.dataSourse.updateDataSource(with: model)
        DispatchQueue.main.async{
            let indexSet = IndexSet(integer: 0)
            self.collectionView.reloadSections(indexSet)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension AdCreatingView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
            guard let visible = collectionView.visibleCells.first else {
                return
            }
            guard let index = collectionView.indexPath(for: visible)?.section else {
                return
            }
            pageControl.currentPage = index
            currentPage = index

        backButton.isHidden = currentPage == 0
        stackView.addArrangedSubviews([backButton, forwardButton])        
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
