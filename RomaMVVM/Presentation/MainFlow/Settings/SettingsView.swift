//
//  SettingsView.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 14.12.2021.
//

import Combine
import UIKit

enum SettingsViewAction {
    case selectedItem(SettingsItem)
}

final class SettingsView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<SettingsSection, SettingsItem>?

    // MARK: - Private properties
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SettingsViewAction, Never>()

    // MARK: - Subviews
    private lazy var collection: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .systemGroupedBackground
        configuration.showsSeparators = false

        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collection
    }()

    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        setupCollection()
        bindActions()
    }

    private func setupCollection() {
        collection.register(UserProfileCell.self)
        collection.register(PlainCell.self)
        
        setupDataSource()
    }

    private func bindActions() {
        collection.didSelectItemPublisher
            .compactMap { self.dataSource?.itemIdentifier(for: $0) }
            .map { SettingsViewAction.selectedItem($0) }
            .sink { [unowned self] in actionSubject.send($0) }
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

    // MARK: - View constants
    private enum Constants {
        static let inset: CGFloat = 16
        static let buttonHeight: CGFloat = 50
    }
}

// MARK: - extensions
extension SettingsView {
    func setupSnapShot(sections: [SettingsCollection]) {
        var snapshot = NSDiffableDataSourceSnapshot<SettingsSection, SettingsItem>()
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapshot)
    }

    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SettingsSection, SettingsItem>(
            collectionView: collection,
            cellProvider: { 
                collectionView, indexPath, item -> UICollectionViewCell in
                    switch item {
                    case let .plain(title):
                        let cell: PlainCell = collectionView.dedequeueReusableCell(for: indexPath)
                        cell.setupCell(title: title)
                        return cell
                        
                    case let .userProfile(model):
                        let cell: UserProfileCell = collectionView.dedequeueReusableCell(for: indexPath)
                        cell.setupCell(model: model)
                        return cell
                    }
            }
        )
    }
}

import SwiftUI
struct SettingsViewPreview: PreviewProvider {
    static var previews: some View {
        ViewRepresentable(SettingsView())
    }
}
