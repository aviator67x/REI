//
//  SettingsView.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 14.12.2021.
//

import Combine
import UIKit

enum SettingsViewAction {
    case logoutTapped
}

struct UserProfileCellModel: Hashable {
    let name: String
    let email: String
//    let image: ImageResource
}

enum SettingsSection: CaseIterable {
    case userProfile
    case profile
    case terms
    case company
}

enum SettingsItem: Hashable {
    case userProfile(userModel: UserProfileCellModel)
    case plain(title: String)
}

final class SettingsView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<SettingsSection, SettingsItem>?

    // MARK: - Private properties
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SettingsViewAction, Never>()

    // MARK: - Subviews
//    var collectionView: UICollectionView!

    let settingsCollections = [      
        SettingsCollection(section: .userProfile,
            items: [.userProfile(userModel: UserProfileCellModel(name: "John", email: "johnBrown@mail.com"))]),
        SettingsCollection(section: .profile, items: [.plain(title: "Profile"), .plain(title: "TermsAndConditions")]),
        SettingsCollection(section: .company, items: [.plain(title: "Company"), .plain(title: "FAQ")]),
    ]

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

    private lazy var collection: UICollectionView = {
//        let layout = UICollectionViewCompositionalLayout { [unowned self] index, environment in
//
//            switch index {
//            case 0:
//                var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//
//                configuration.headerMode = .supplementary
//
//                return .list(using: configuration, layoutEnvironment: environment)
//
//            default:
//                let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
//
//                return .list(using: configuration, layoutEnvironment: environment)
//            }
//
//        }

//        The second approach
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .systemBlue
        configuration.showsSeparators = true
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
    
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collection
    }()

    private func setupCollection() {
        collection.register(UserProfileCell.self, forCellWithReuseIdentifier: UserProfileCell.identifier)
        collection.register(PlainCell.self, forCellWithReuseIdentifier: PlainCell.identifier)
        setupDataSource()
        setupSnapShot(sections: settingsCollections)
    }

    private func bindActions() {}

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

// MARK: - UITableViewDataSource
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
            cellProvider: { [unowned self]
                collectionView, indexPath, item -> UICollectionViewCell in
                    switch item {
                    case let .plain(title):
                        guard let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: PlainCell.identifier,
                            for: indexPath
                        ) as? PlainCell else {
                            return UICollectionViewCell()
                        }
                        cell.setupCell(title: title)
                        return cell
                    case let .userProfile(model):
                        guard let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: UserProfileCell.identifier,
                            for: indexPath
                        ) as? UserProfileCell else { return UICollectionViewCell() }
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
