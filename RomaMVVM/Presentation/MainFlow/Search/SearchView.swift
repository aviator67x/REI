//
//  SearchView.swift
//  RomaMVVM
//
//  Created by User on 24.03.2023.
//

import UIKit
import Combine

enum SearchViewAction {

}

enum SearchSection: Hashable {
    case distance
    case price
    case type
    case square
    case roomsNumber
    case year
    case garage
}

enum SearchItem: Hashable {
    case distance
    case price
    case type
    case square
    case roomsNumber
    case year
    case garage
}

final class SearchView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<SearchSection, SearchItem>?
    
    // MARK: - Subviews
    
    private lazy var collection: UICollectionView = {
        let sectionProvider =
            { [weak self] (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                var section: NSCollectionLayoutSection
                var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
                section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)
                return section
            }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SearchViewAction, Never>()
    
    private var searchCollections = [SearchCollection]()

    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }

    private func bindActions() {
    }

    private func setupUI() {
        backgroundColor = .systemGroupedBackground
    }
    
    private func setupCollection() {
        setupDataSource()
        collection.register(DistanceCell.self, forCellWithReuseIdentifier: DistanceCell.reusedidentifier)
        setupSnapshot(sections: searchCollections)
    }

    private func setupLayout() {
    }
}

// MARK: - View constants
private enum Constant {
}

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
        UICollectionViewDiffableDataSource<SearchSection, SearchItem>(collectionView: collection, cellProvider: { [unowned self] collection, indexPath, item -> UICollectionViewCell in
            switch item {
            case .distance:
                guard let cell = collection.dequeueReusableCell(withReuseIdentifier: DistanceCell.reusedidentifier, for: indexPath) as? DistanceCell else { return UICollectionViewCell()}
                return cell
            case .price:
                guard let cell = collection.dequeueReusableCell(withReuseIdentifier: PriceCell.reusedidentifier, for: indexPath) as? PriceCell else { return UICollectionViewCell()}
                return cell
            case .type:
                guard let cell = collection.dequeueReusableCell(withReuseIdentifier: TypeCell.reusedidentifier, for: indexPath) as? TypeCell else { return UICollectionViewCell()}
                return cell
            case .square:
                guard let cell = collection.dequeueReusableCell(withReuseIdentifier: SquareCell.reusedidentifier, for: indexPath) as? SquareCell else { return UICollectionViewCell()}
                return cell
            case .roomsNumber:
                guard let cell = collection.dequeueReusableCell(withReuseIdentifier: RoomsNumberCell.reusedidentifier, for: indexPath) as? RoomsNumberCell else { return UICollectionViewCell()}
                return cell
            case .year:
                guard let cell = collection.dequeueReusableCell(withReuseIdentifier: YearCell.reusedidentifier, for: indexPath) as? YearCell else { return UICollectionViewCell()}
                return cell
            case .garage:
                guard let cell = collection.dequeueReusableCell(withReuseIdentifier: GarageCell.reusedidentifier, for: indexPath) as? GarageCell else { return UICollectionViewCell()}
                return cell
            }
        })
    }
}
