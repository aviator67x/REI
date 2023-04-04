//
//  ConstructionYearView.swift
//  RomaMVVM
//
//  Created by User on 03.04.2023.
//

import UIKit
import Combine
import Foundation

enum ConstructionYearViewAction {
    case selectedItem(ConstructionYearItem)

}
struct ConstructionYearCollection {
    var section: ConstructionYearSection
    var items: [ConstructionYearItem]
}

enum ConstructionYearSection: Hashable {
    case plain
}

enum ConstructionYearItem: Hashable {
    case plain(String)
}

final class ConstructionYearView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<ConstructionYearSection, ConstructionYearItem>?
    // MARK: - Subviews

    private var collection: UICollectionView!
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<ConstructionYearViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        collection = createCollection()
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
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
            .map {ConstructionYearViewAction.selectedItem($0)}
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
struct ConstructionYearPreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(ConstructionYearView())
    }
}
#endif

// MARK: - extensions
extension ConstructionYearView {
    func setupSnapShot(sections: [ConstructionYearCollection]) {
        var snapshot = NSDiffableDataSourceSnapshot<ConstructionYearSection, ConstructionYearItem>()
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapshot)
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<ConstructionYearSection, ConstructionYearItem>(collectionView: collection, cellProvider: {
            collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .plain(let year1850):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailedCell.identifier, for: indexPath) as? DetailedCell else { return UICollectionViewCell()}
                cell.setupCell(title: year1850)
                
                return cell
            case .plain(let year1900):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailedCell.identifier, for: indexPath) as? DetailedCell else { return UICollectionViewCell()}
                cell.setupCell(title: year1900)
                
                return cell
            case .plain(let year1950):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailedCell.identifier, for: indexPath) as? DetailedCell else { return UICollectionViewCell()}
                cell.setupCell(title: year1950)
                
                return cell
            case .plain(let year2000):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailedCell.identifier, for: indexPath) as? DetailedCell else { return UICollectionViewCell()}
                cell.setupCell(title: year2000)
                
                return cell
            case .plain(let year2010):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailedCell.identifier, for: indexPath) as? DetailedCell else { return UICollectionViewCell()}
                cell.setupCell(title: year2010)
                
                return cell
            case .plain(let year2020):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailedCell.identifier, for: indexPath) as? DetailedCell else { return UICollectionViewCell()}
                cell.setupCell(title: year2020)
                
                return cell
            }
        })
    }
}
