//
//  SearchView.swift
//  RomaMVVM
//
//  Created by User on 24.03.2023.
//

import Combine
import Foundation
import UIKit

enum SearchViewAction {}

enum SearchSection: Hashable, CaseIterable {
    case segmentControl
    case distance
    case price
//    case type
//    case square
//    case roomsNumber
//    case year
//    case garage
}

enum SearchItem: Hashable {
    case segmentControl
    case distance(String)
    case price
//    case type
//    case square
//    case roomsNumber
//    case year
//    case garage
}

final class SearchView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<SearchSection, SearchItem>?

    // MARK: - Subviews

    private lazy var collection: UICollectionView = {
        let sectionProvider =
            { [weak self] (sectionNumber: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                var section: NSCollectionLayoutSection?
                let sectionType = SearchSection.allCases
                switch sectionType[sectionNumber] {
                case .segmentControl:
                    section = self?.segmentControlSectionLayout()
                case .distance:
                    section = self?.distanceSectionLayout()
                case .price:
                    section = self?.priceSectionLayout()
//                case .type:
//                    section = self?.typeSectionaLayout()
                }

                return section
            }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SearchViewAction, Never>()

    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func segmentControlSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(70)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

        return section
    }

    private func distanceSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(36)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(EdgeInsets(top: 0, leading: 35, bottom: 0, trailing: 20))
        group.interItemSpacing = .fixed(6)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: "header",
            alignment: .top
        )

        let backgroundFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(4)
        )
        let backgroundFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: backgroundFooterSize,
            elementKind: "BackgroundFooter",
            alignment: .bottom
        )

        section.boundarySupplementaryItems = [header, backgroundFooter]

        return section
    }

    private func priceSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(60)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
        
        let backgroundFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(4)
        )
        let backgroundFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: backgroundFooterSize,
            elementKind: "BackgroundFooter",
            alignment: .bottom
        )

        let priceHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(44)
        )
        let priceHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: priceHeaderSize,
            elementKind: "header",
            alignment: .top
        )

        section.boundarySupplementaryItems = [backgroundFooter, priceHeader]

        return section
    }


    private func initialSetup() {
        setupLayout()
        setupUI()
        setupCollection()
        bindActions()
    }

    private func bindActions() {}

    private func setupUI() {}

    private func setupCollection() {
        collection.register(
            BackgroundFooterView.self,
            forSupplementaryViewOfKind: "BackgroundFooter",
            withReuseIdentifier: "BackgroundFooter"
        )
        collection.register(
            HeaderView.self,
            forSupplementaryViewOfKind: "header",
            withReuseIdentifier: "Header"
        )
        collection.register(SegmentControlCell.self, forCellWithReuseIdentifier: SegmentControlCell.reusedidentifier)
        collection.register(DistanceCell.self, forCellWithReuseIdentifier: DistanceCell.reusedidentifier)
        collection.register(PriceCell.self, forCellWithReuseIdentifier: PriceCell.reusedidentifier)
        collection.register(TypeCell.self, forCellWithReuseIdentifier: TypeCell.reusedidentifier)
        setupDataSource()
    }

    private func setupLayout() {
        addSubview(collection) {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - View constants
private enum Constant {}

#if DEBUG
    import SwiftUI
    struct SearchPreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(SearchView())
        }
    }
#endif

// MARK: - extension
extension SearchView {
    func setupSnapshot(sections: [SearchCollection]) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchSection, SearchItem>()
        for section in sections {
            snapshot.appendSections([section.sections])
            snapshot.appendItems(section.items, toSection: section.sections)
        }
        dataSource?.apply(snapshot)
    }

    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SearchSection, SearchItem>(
            collectionView: collection,
            cellProvider: { [unowned self] _, indexPath, item -> UICollectionViewCell in
                switch item {
                case .segmentControl:
                    guard let cell = collection.dequeueReusableCell(
                        withReuseIdentifier: SegmentControlCell.reusedidentifier,
                        for: indexPath
                    ) as? SegmentControlCell else { return UICollectionViewCell() }

                    return cell
                case let .distance(km):
                    guard let cell = collection.dequeueReusableCell(
                        withReuseIdentifier: DistanceCell.reusedidentifier,
                        for: indexPath
                    ) as? DistanceCell else { return UICollectionViewCell() }
                    cell.setupCell(with: km)

                    return cell
                case .price:
                    guard let cell = collection.dequeueReusableCell(
                        withReuseIdentifier: PriceCell.reusedidentifier,
                        for: indexPath
                    ) as? PriceCell else { return UICollectionViewCell() }

                    return cell
//                case .type:
//                    guard let cell = collection.dequeueReusableCell(
//                        withReuseIdentifier: TypeCell.reusedidentifier,
//                        for: indexPath
//                    ) as? TypeCell else { return UICollectionViewCell() }
//
//                    return cell
                }
            }
        )
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case "header":
                guard let header: HeaderView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: "header",
                    withReuseIdentifier: "Header",
                    for: indexPath
                ) as? HeaderView else { return UICollectionReusableView() }
               
                let sectionType = SearchSection.allCases
                switch sectionType[indexPath.section] {
                case .distance:
                    header.setupUI(text: "Distance", imageName: "plus")
                case .price:
                    header.setupUI(text: "Price category", imageName: "eurosign")
                case .segmentControl:
                    header.setupUI(text: "Price category", imageName: "eurosign")
                }
                
                return header
            case "BackgroundFooter":
                guard let footer: BackgroundFooterView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: "BackgroundFooter",
                    withReuseIdentifier: "BackgroundFooter",
                    for: indexPath
                ) as? BackgroundFooterView else { return UICollectionReusableView() }

                return footer
            default:
                return UICollectionReusableView()
            }
        }
    }
}
