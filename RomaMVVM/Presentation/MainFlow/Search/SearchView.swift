//
//  SearchView.swift
//  RomaMVVM
//
//  Created by User on 24.03.2023.
//

import Combine
import UIKit
import Foundation

enum SearchViewAction {}

enum SearchSection: Hashable, CaseIterable {
    case distance
    case price
//    case type
//    case square
//    case roomsNumber
//    case year
//    case garage
}

enum SearchItem: Hashable {
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
            { [weak self] (sectionNumber : Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                var section: NSCollectionLayoutSection?
                let sectionType = SearchSection.allCases
                switch sectionType[sectionNumber] {
                case .distance:
                   section =  self?.distanceSectionLayout()
                case .price:
                    section =  self?.priceSectionLayout()
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

    private func distanceSectionLayout() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(1),
            heightDimension: .absolute(30)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(35)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(EdgeInsets(top: 0, leading: 23, bottom: 0, trailing: 20))
        group.interItemSpacing = .fixed(5)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0))
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)

        section.boundarySupplementaryItems = [header]

        return section
    }
    
    
    private func priceSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 2)

        let section = NSCollectionLayoutSection(group: group)

        return section
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        setupCollection()
        bindActions()
    }

    private func bindActions() {}

    private func setupUI() {
        backgroundColor = .systemGroupedBackground
    }

    private func setupCollection() {
        collection.register(DistanceHeaderView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "DistanceHeader")
        collection.register(PriceHeaderView.self, forSupplementaryViewOfKind: PriceHeaderView.identifier, withReuseIdentifier: PriceHeaderView.identifier)
        collection.register(DistanceCell.self, forCellWithReuseIdentifier: DistanceCell.reusedidentifier)
        collection.register(PriceCell.self, forCellWithReuseIdentifier: PriceCell.reusedidentifier)
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
            cellProvider: { [unowned self] collectionView, indexPath, item -> UICollectionViewCell in
                switch item {
                case .distance(let km):
                    guard let cell = collection.dequeueReusableCell(withReuseIdentifier: DistanceCell.reusedidentifier, for: indexPath) as? DistanceCell else { return UICollectionViewCell()}
                    cell.setupCell(with: km)
                    return cell
                case .price:
                    guard let cell = collection.dequeueReusableCell(withReuseIdentifier: PriceCell.reusedidentifier, for: indexPath) as? PriceCell else { return UICollectionViewCell()}
                    
                    return cell
                }
            }
        )
        dataSource?.supplementaryViewProvider = {(collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let header: DistanceHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: "DistanceHeader", for: indexPath) as? DistanceHeaderView else {return UICollectionReusableView()}

            return header
        }
    }
}
