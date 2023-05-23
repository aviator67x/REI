//
//  ConstructionYearView.swift
//  RomaMVVM
//
//  Created by User on 03.04.2023.
//

import UIKit
import Combine
import Foundation

enum SearchFiltersDetailedViewAction {
    case selectedItem(SearchFiltersDetailedItem)

}

final class SearchFiltersDetailedView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<SearchFiltersDetailedSection, SearchFiltersDetailedItem>?
    // MARK: - Subviews

    private var collection: UICollectionView!
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SearchFiltersDetailedViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        collection = createCollection()
        setupLayout()
        setupUI()
        setupCollection()
        bindActions()
    }
    
    private func createCollection() -> UICollectionView {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.backgroundColor = .systemGroupedBackground
        configuration.showsSeparators = false

        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collection
    }
    
    private func setupCollection() {
        collection.register(DetailedCell.self, forCellWithReuseIdentifier: DetailedCell.identifier)
        setupDataSource()
    }

    private func bindActions() {
        collection.didSelectItemPublisher
            .compactMap {self.dataSource?.itemIdentifier(for: $0)}
            .map {SearchFiltersDetailedViewAction.selectedItem($0)}
            .sink { [unowned self] in
                actionSubject.send($0)}
            .store(in: &cancellables)
        
    }

    private func setupUI() {
        backgroundColor = .white
    }

    private func setupLayout() {
        addSubview(collection) {
            $0.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        }
    }
}

// MARK: - View constants
private enum Constant {
}

#if DEBUG
import SwiftUI
struct DetailedPreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(SearchFiltersDetailedView())
    }
}
#endif

// MARK: - extensions
extension SearchFiltersDetailedView {
    func setupSnapShot(sections: [SearchFiltersDetailedCollection]) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchFiltersDetailedSection, SearchFiltersDetailedItem>()
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapshot)
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SearchFiltersDetailedSection, SearchFiltersDetailedItem>(collectionView: collection, cellProvider: {
            collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .plainYear(let year):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailedCell.identifier, for: indexPath) as? DetailedCell else { return UICollectionViewCell()}
                cell.setupCell(yearTitle: year)
                return cell
                
            case .plainGarage(let garage):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailedCell.identifier, for: indexPath) as? DetailedCell else { return UICollectionViewCell()}
                cell.setupCell(garageTitle: garage)
                return cell
            }
        })
    }
}
