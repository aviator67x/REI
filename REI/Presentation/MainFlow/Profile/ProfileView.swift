//
//  ProfileView.swift
//  REI
//
//  Created by User on 20.03.2023.
//

import Combine
import UIKit

enum ProfileViewAction {
    case selectedItem(ProfileItem)
}

final class ProfileView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<ProfileSection, ProfileItem>?

    // MARK: - Subviews
    private lazy var collectionView: UICollectionView = createCollectionView()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<ProfileViewAction, Never>()

    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    // MARK: - Life cycle
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createCollectionView() -> UICollectionView {
        let sectionProvider =
            { (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                var section: NSCollectionLayoutSection
                let listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)
                return section
            }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collection
    }

    // MARK: - Private methods
    private func initialSetup() {
        setupLayout()
        setupUI()
        setupCollectionView()
        bindActions()
    }

    private func bindActions() {
        collectionView.didSelectItemPublisher
            .compactMap { self.dataSource?.itemIdentifier(for: $0) }
            .map { ProfileViewAction.selectedItem($0) }
            .sink { [unowned self] in actionSubject.send($0) }
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .systemGroupedBackground
    }

    private func setupCollectionView() {
        collectionView.register(PlainCell.self)
        collectionView.register(ButtonCell.self)
        collectionView.register(UserDataCell.self)
        collectionView.register(BackgroundCell.self)
        
        setupDataSource()
    }

    private func setupLayout() {
        addSubview(collectionView) {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - extension
extension ProfileView {
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
            cellProvider: {
                collectionView, indexPath, item -> UICollectionViewCell in
                switch item {
                case let .plain(title):
                    let cell: PlainCell = collectionView.dedequeueReusableCell(for: indexPath)
                    cell.setupCell(title: title.rawValue)
                    return cell
                    
                case .button:
                    let cell: ButtonCell = collectionView.dedequeueReusableCell(for: indexPath)
                    return cell
                    
                case let .userData(user):
                    let cell: UserDataCell = collectionView.dedequeueReusableCell(for: indexPath)
                    cell.setup(user)
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
    struct ProfilePreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(ProfileView())
        }
    }
#endif
