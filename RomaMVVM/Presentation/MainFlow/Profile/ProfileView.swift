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
    private let scrollView = UIScrollView()
    private let userView = UIView()
    private let photo = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private lazy var collectionView: UICollectionView = {
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: "header", alignment: .top, absoluteOffset: CGPoint(x: 0, y: 0))
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .systemGroupedBackground
        configuration.showsSeparators = false
//        configuration.headerMode = .supplementary
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
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
        
        photo.layer.cornerRadius = 60
        photo.clipsToBounds = true
        photo.image = UIImage(named: "girl")
        
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        nameLabel.text = "NameLabel"
        
        emailLabel.text = "EmailLabel"
    }
    
    private func setupCollectionView() {
        collectionView.register(PlainCell.self, forCellWithReuseIdentifier: PlainCell.identifier)
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.identifier)
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: "header",
            withReuseIdentifier: "SectionHeader"
        )
        setupDataSource()
        setupSnapShot(sections: profileCollections)
    }

    private func setupLayout() {
        addSubview(scrollView) {
            $0.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        }
        
        scrollView.addSubview(userView) {
            $0.top.width.equalToSuperview()
        }
        
        userView.addSubview(photo) {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(120)
            $0.top.equalToSuperview().offset(20)
        }
        
        userView.addSubview(nameLabel) {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(photo.snp.bottom).offset(10)
        }
        
        userView.addSubview(emailLabel) {
            $0.centerX.bottom.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        scrollView.addSubview(collectionView) {
            $0.width.bottom.equalToSuperview()
            $0.height.equalTo(500)
            $0.top.equalTo(userView.snp.bottom)
        }
    }
}

// MARK: - extension
extension ProfileView {
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
