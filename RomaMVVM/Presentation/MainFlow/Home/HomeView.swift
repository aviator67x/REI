//
//  HomeView.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 14.12.2021.
//

import Combine
import UIKit

struct Section {
    let images: [UIView]
}

enum HomeViewAction {
  case avatarButtonDidTap
}

final class HomeView: BaseView {
    var sections: [Section] = []
    var images: [UIView] = []
    
    private let scrollView = AxisScrollView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let tokenLabel = UILabel()
    private let idLabel = UILabel()
    private let galleryImage = UIImageView()
    private let avatarButton = BaseButton(buttonState: .avatar)

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<HomeViewAction, Never>()
    
    private var compositionalLayout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
        let badgeSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let containerAnchor = NSCollectionLayoutAnchor(edges: [.bottom], absoluteOffset: CGPoint(x: 0, y: 10))
        let badge = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: badgeSize, elementKind: "badge", containerAnchor: containerAnchor)
        

        let itemsPerRow = environment.traitCollection.horizontalSizeClass == .compact ? 3 : 6
        let fraction: CGFloat = 1 / CGFloat(itemsPerRow)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(fraction),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
        let contentInset: CGFloat = 3
        item.contentInsets = NSDirectionalEdgeInsets(
            top: contentInset,
            leading: contentInset,
            bottom: contentInset,
            trailing: contentInset
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1/2)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "footer", alignment: .bottom)
        section.boundarySupplementaryItems = [header, footer]
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private lazy var imagesCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collection.backgroundColor = .gray
        collection.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collection.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: "header",
            withReuseIdentifier: "SectionHeader"
        )
        collection.register(SectionFooterView.self,
                            forSupplementaryViewOfKind: "footer",
                            withReuseIdentifier: "SectionFooter")
        collection.register(BadgeView.self, forSupplementaryViewOfKind: "badge", withReuseIdentifier: "BadgeView")
        collection.dataSource = self
        return collection
    }()
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUser(_ user: UserModel) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        tokenLabel.text = user.accessToken
        idLabel.text = user.id
    }
    
    func updateGalleryImage(image: UIImage) {
        galleryImage.image = image
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
        createCollectionData()
    }

    private func bindActions() {
        avatarButton.tapPublisher
            .sink { [unowned self] in
                self.actionSubject.send(.avatarButtonDidTap)
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .lightGray
        let labels = [nameLabel, emailLabel, tokenLabel, idLabel]
        labels.forEach { label in
            label.backgroundColor = .yellow
            label.bordered(width: 1, color: .red)
        }
        galleryImage.backgroundColor = .black
    }

    private func setupLayout() {
        
        let stack = UIStackView()
        stack.setup(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 8)
        stack.addCentered(nameLabel, inset: 16, size: 50)
        stack.addCentered(emailLabel, inset: 16, size: 50)
        stack.addCentered(tokenLabel, inset: 16, size: 50)
        stack.addCentered(idLabel, inset: 16, size: 50)
        stack.addCentered(galleryImage, inset: 16, size: 100)
        stack.addSpacer(20)
        stack.addCentered(imagesCollectionView, inset: 16, size: 200)
        stack.addSpacer(20)
        stack.addCentered(avatarButton, inset: 16, size: 50)
        
        addSubview(scrollView, withEdgeInsets: .zero, safeArea: false)
        scrollView.contentView.addSubview(stack, withEdgeInsets: UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0))
    }

   
    private func createCollectionData() {
        for _ in 0 ... 5 {
            for _ in 0 ... 6 {
                let photoView = UIView(frame: .zero)
                photoView.backgroundColor = .green
               
                images.append(photoView)
            }
            let section = Section(images: images)
            sections.append(section)
            images = []
        }
    }
}

// MARK: - View constants
private enum Constant {
   
}

extension HomeView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].images.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell
        else {
            return UICollectionViewCell()
        }

        let backgroundcolor = UIColor(
            red: CGFloat(arc4random()),
            green: CGFloat(arc4random()),
            blue: CGFloat(arc4random()),
            alpha: 1.0
        )

        cell.photo.backgroundColor = .systemBlue
        
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case "header":
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                 ofKind: kind,
                 withReuseIdentifier: "SectionHeader",
                 for: indexPath
            ) as? SectionHeaderView else {
                return SectionHeaderView()
            }
            headerView.nameLabel.text = "Section \(indexPath.section)"
             return headerView
        case "footer":
            guard let footerView = collectionView.dequeueReusableSupplementaryView(
                 ofKind: kind,
                 withReuseIdentifier: "SectionFooter",
                 for: indexPath
            ) as? SectionFooterView else {
                return SectionFooterView()
            }
            return footerView
        case "badge":
            guard let badgeView = collectionView.dequeueReusableSupplementaryView(
                 ofKind: kind,
                 withReuseIdentifier: "BadgeView",
                 for: indexPath
            ) as? BadgeView else {
                return BadgeView()
            }
            return badgeView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}



