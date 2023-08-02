//
//  HouseImagesView.swift
//  REI
//
//  Created by User on 06.06.2023.
//

import Combine
import UIKit

enum HouseImagesViewAction {
    case current(page: Int)
}

final class HouseImagesView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<HouseImagesSection, HouseImagesItem>?

    // MARK: - Subviews
    private let crossButton = CrossButton()
    private var collectionView: UICollectionView!

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<HouseImagesViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        setupCollectionView()
        setupLayout()
        setupUI()
        bindActions()
    }

    private func bindActions() {}
    
    private func setupCollectionView() {
        collectionView = createPhotoCollectionView()
        collectionView.register(HouseImagesCell.self)
        setupDataSource()
    }

    private func compositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemsPerRow = 1
            let fraction: CGFloat = 1 / CGFloat(itemsPerRow)
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(fraction),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let contentInset: CGFloat = 3
            item.contentInsets = NSDirectionalEdgeInsets(
                top: contentInset,
                leading: contentInset,
                bottom: contentInset,
                trailing: contentInset
            )

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            section.visibleItemsInvalidationHandler = { [weak self] _, offset, _ in
                guard  let self = self else {
                    return
                }
                let width = self.bounds.width
                let pageDouble = offset.x / width
                guard !(pageDouble.isNaN || pageDouble.isInfinite) else {
                    return
                }
                let page = Int(round(pageDouble)) + 1
                self.actionSubject.send(.current(page: page))
            }
            return section
        }
        return layout
    }

    private func createPhotoCollectionView() -> UICollectionView {
        let layout = compositionalLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }

    private func setupUI() {
        backgroundColor = .white
    }

    private func setupLayout() {
        addSubview(collectionView) {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
    }

    func setupSnapshot(sections: [HouseImagesCollection]) {
        var snapshot = NSDiffableDataSourceSnapshot<HouseImagesSection, HouseImagesItem>()
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapshot)
    }

    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HouseImagesSection, HouseImagesItem>(
            collectionView: collectionView,
            cellProvider: {
                collectionView, indexPath, item -> UICollectionViewCell in
                switch item {
                case let .photo(cellModel):
                    let cell: HouseImagesCell = collectionView.dedequeueReusableCell(for: indexPath)
                    cell.setupCell(cellModel)

                    return cell
                }
            }
        )
    }
}

// MARK: - View constants
private enum Constant {}

#if DEBUG
    import SwiftUI
    struct HouseImagesPreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(HouseImagesView())
        }
    }
#endif
