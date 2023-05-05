//
//  FavouriteView.swift
//  RomaMVVM
//
//  Created by User on 27.04.2023.
//

import UIKit
import Combine

enum FavouriteViewAction {

}

final class FavouriteView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<SearchResultsSection, SearchResultsItem>?
    
    // MARK: - Subviews
    private lazy var stackView = UIStackView()
    private lazy var infoView = InfoView()
    private lazy var collectionView: UICollectionView = createCollectionView()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<FavouriteViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCollectionView() -> UICollectionView {
        let sectionProvider =
            { (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                var section: NSCollectionLayoutSection
                var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
                listConfiguration.showsSeparators = true
                section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)

                return section
            }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collection
    }

    private func setupCollectionView() {
        collectionView.register(
            PhotoCell.self,
            forCellWithReuseIdentifier: PhotoCell.reusedidentifier
        )
        setupDataSource()
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        setupCollectionView()
        bindActions()
    }

    private func bindActions() {
    }

    private func setupUI() {
        backgroundColor = .white
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
    }

    private func setupLayout() {
        addSubview(infoView) {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
        }
        addSubview(collectionView) {
            $0.top.equalTo(infoView.snp.bottom)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - extension
extension FavouriteView {
    func setupSnapShot(sections: [SearchResultsCollection]) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchResultsSection, SearchResultsItem>()
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapshot)
    }

    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SearchResultsSection, SearchResultsItem>(
            collectionView: collectionView,
            cellProvider: {
                collectionView, indexPath, item -> UICollectionViewCell in
                switch item {
                case let .photo(model):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: PhotoCell.reusedidentifier,
                        for: indexPath
                    ) as? PhotoCell else {
                        return UICollectionViewCell()
                    }
                    cell.setupCell(model)
                    return cell
                case let .main(model):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MainCell.reusedidentifier,
                        for: indexPath
                    ) as? MainCell else {
                        return UICollectionViewCell()
                    }
                    cell.setupCell(model)
                    return cell
                case let .list(model):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ListCell.reusedidentifier,
                        for: indexPath
                    ) as? ListCell else {
                        return UICollectionViewCell()
                    }
                    cell.setupCell(model)
                    return cell
                case .map:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MapCell.reusedidentifier,
                        for: indexPath
                    ) as? MapCell else {
                        return UICollectionViewCell()
                    }
                    return cell
                }
            }
        )
    }
}

// MARK: - View constants
private enum Constant {
}

#if DEBUG
import SwiftUI
struct FavouritePreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(FavouriteView())
    }
}
#endif