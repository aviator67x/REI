//
//  ProfileView.swift
//  RomaMVVM
//
//  Created by User on 20.03.2023.
//

import Combine
import UIKit

enum ProfileSection: Hashable {
    case details
    case button
}

enum ProfileItem: Hashable {
    case plain(String)
    case button
}

enum ProfileViewAction {
    case selectedItem(ProfileItem)
}

final class ProfileView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<ProfileSection, ProfileItem>?
    
    // MARK: - Subviews
    private lazy var collectionView: UICollectionView = {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top, absoluteOffset: CGPoint(x: 0, y: 0))
        
        let sectionProvider = { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                var section: NSCollectionLayoutSection
                var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                if sectionIndex == 0 {
                    listConfiguration.headerMode = .supplementary
                } else {
                    listConfiguration.headerMode = .none
                }
                section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)
                return section
            }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
//        collectionView.setCollectionViewLayout(layout, animated: true)
        
//        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//        configuration.backgroundColor = .systemGroupedBackground
//        configuration.showsSeparators = true
//        configuration.headerMode = .supplementary
//
//        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collection
    }()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<ProfileViewAction, Never>()
    
    private var profileCollections = [ProfileCollection]()

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
        setupCollectionView()
        bindActions()
    }

    private func bindActions() {
        collectionView.didSelectItemPublisher
            .compactMap { self.dataSource?.itemIdentifier(for: $0)}
            .map { ProfileViewAction.selectedItem($0)}
            .sink { [unowned self] in actionSubject.send($0)}
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .systemGroupedBackground
    }
    
    private func setupCollectionView() {
        collectionView.register(PlainCell.self, forCellWithReuseIdentifier: PlainCell.identifier)
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.identifier)
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseidentifier
        )
        setupDataSource()
        setupSnapShot(sections: profileCollections)
    }

    private func setupLayout() {        
     addSubview(collectionView) {
         $0.edges.equalToSuperview()
        }
    }
}

// MARK: - extension
extension ProfileView {
    func updateUserView(_ user: UserDomainModel) {
//        nameLabel.text = user.name
//        emailLabel.text = user.email
    }
    
    func updateProfileCollection(_ value: [ProfileCollection]) {
        setupSnapShot(sections: value)
    }
    
    func setupSnapShot(sections: [ProfileCollection]) {
        var snapshot = NSDiffableDataSourceSnapshot<ProfileSection, ProfileItem>()
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapshot)
    }
        
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<ProfileSection, ProfileItem>(
            collectionView: collectionView,
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
                    case .button:
                        guard let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: ButtonCell.identifier,
                            for: indexPath
                        ) as? ButtonCell else {
                            return UICollectionViewCell()
                        }
                        return cell
                    }
            }
        )
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            // 2
//            guard kind == UICollectionView.elementKindSectionHeader else {
//              return nil
//            }
            let view = collectionView.dequeueReusableSupplementaryView(
              ofKind: kind,
              withReuseIdentifier: SectionHeaderView.reuseidentifier,
              for: indexPath) as? SectionHeaderView
//            let section = self.dataSource?.snapshot()
//              .sectionIdentifiers[indexPath.section]
            return view
          }
    }
}

// MARK: - View constants
private enum Constant {}

#if DEBUG
    import SwiftUI
    struct ProfilePreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(ProfileView())
        }
    }
#endif
