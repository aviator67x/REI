//
//  FavouriteView.swift
//  RomaMVVM
//
//  Created by User on 27.04.2023.
//

import Combine
import UIKit

enum FavouriteViewAction {
    case selectedItem(FavouriteItem)
}

final class FavouriteView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<FavouriteSection, FavouriteItem>?

    // MARK: - Subviews
    private lazy var stackView = UIStackView()
    private lazy var infoView = InfoView()
    private lazy var collectionView: UICollectionView = createCollectionView()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<FavouriteViewAction, Never>()

    private var itemSubject = PassthroughSubject<FavouriteItem, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createCollectionView() -> UICollectionView {
        let sectionProvider =
            { (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                var section: NSCollectionLayoutSection
                var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
                listConfiguration.showsSeparators = true

                listConfiguration.trailingSwipeActionsConfigurationProvider = { indexPath in
                    let del = UIContextualAction(style: .destructive, title: "Delete") {
                        [weak self] _, _, _ in
                        if let item = self?.dataSource?.itemIdentifier(for: indexPath) {
                            self?.itemSubject.send(item)
                        }
                    }

                    return UISwipeActionsConfiguration(actions: [del])
                }
                section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)

                return section
            }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collection
    }

    private func setupCollectionView() {
        collectionView.register(FavouriteCell.self)

        setupDataSource()
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        setupCollectionView()
        bindActions()
    }

    private func bindActions() {
        itemSubject
            .map { FavouriteViewAction.selectedItem($0) }
            .sink { [unowned self] in
                actionSubject.send($0)
            }
            .store(in: &cancellables)
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
    func updateInfoView(with count: Int) {
        infoView.setup(with: count)
    }

    func setupSnapShot(sections: [FavouriteCollection]) {
        var snapshot = NSDiffableDataSourceSnapshot<FavouriteSection, FavouriteItem>()
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapshot)
    }

    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<FavouriteSection, FavouriteItem>(
            collectionView: collectionView,
            cellProvider: {
                collectionView, indexPath, item -> UICollectionViewCell in
                switch item {
                case let .photo(model):
                    let cell: FavouriteCell = collectionView.dedequeueReusableCell(for: indexPath)
                    cell.setupCell(model)
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
    struct FavouritePreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(FavouriteView())
        }
    }
#endif
