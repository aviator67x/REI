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
    case chosePhotoDidTap
    case logoutDidTap
}

final class HomeView: BaseView {
    var sections: [Section] = []
    var images: [UIView] = []

    // MARK: - Views
    private let scrollView = AxisScrollView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let tokenLabel = UILabel()
    private let idLabel = UILabel()
    private let chosePhotoButton = BaseButton(buttonState: .chosePhoto)
    private let galleryImage = UIImageView()
    private let avatarButton = BaseButton(buttonState: .avatar)
    private let logoutButton = BaseButton(buttonState: .logout)
    
    // MARK: - Private properties
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<HomeViewAction, Never>()

  
  
    // MARK: - LifeCycle
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
        bindActions()
        createCollectionData()
    }

    private func bindActions() {
        avatarButton.tapPublisher
            .sink { [unowned self] in
                self.actionSubject.send(.avatarButtonDidTap)
            }
            .store(in: &cancellables)

        chosePhotoButton.tapPublisher
            .sink { [unowned self] in
                self.actionSubject.send(.chosePhotoDidTap)
            }
            .store(in: &cancellables)
        
        logoutButton.tapPublisher
            .sink { [unowned self] in
                self.actionSubject.send(.logoutDidTap)
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .white
        let labels = [nameLabel, emailLabel, tokenLabel, idLabel]
        labels.forEach { label in
            label.backgroundColor = .white
            label.layer.cornerRadius = 6
            label.bordered(width: 1, color: .gray)
        }
        galleryImage.backgroundColor = .black
    }

    private func setupLayout() {
        let stack = UIStackView()
        stack.setup(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 8)
        stack.addCentered(nameLabel, inset: Constants.inset, size: Constants.height)
        stack.addCentered(emailLabel, inset: Constants.inset, size: Constants.height)
        stack.addCentered(tokenLabel, inset: Constants.inset, size: Constants.height)
        stack.addCentered(idLabel, inset: Constants.inset, size: Constants.height)
        stack.addSpacer(20)
        stack.addCentered(chosePhotoButton, inset: Constants.inset, size: Constants.height)
        stack.addCentered(galleryImage, inset: Constants.inset, size: 100)
        stack.addSpacer(20)
        stack.addCentered(avatarButton, inset: Constants.inset, size: Constants.height)
        stack.addSpacer(20)
        stack.addCentered(logoutButton, inset: Constants.inset, size: 50)

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
private enum Constants {
    static let inset: CGFloat = 16
    static let height: CGFloat = 50
}

// MARK: - extension
extension HomeView {
    func updateUser(_ user: UserDomainModel) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        idLabel.text = user.id
    }

    func setAvatar(imageResource: ImageResource) {
        galleryImage.setIMage(imageResource: imageResource)
    }
}

// MARK: - extension UICollectionViewDataSource
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
//            headerView.nameLabel.text = "Section \(indexPath.section)"
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
            assertionFailure("Unexpected element kind")
            return BadgeView()
        }
    }
}
