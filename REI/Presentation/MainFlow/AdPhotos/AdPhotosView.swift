//
//  AdPhotosView.swift
//  RomaMVVM
//
//  Created by User on 25.05.2023.
//

import Combine
import UIKit

enum AdPhotosViewAction {
    case crossDidTap
    case backDidTap
    case addPhotoDidTap
    case createAdDidTap
    case deletePhoto(HousePhotoItem)
}

final class AdPhotosView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<HousePhotoSection, HousePhotoItem>?
    
    // MARK: - Subviews
    private let pageControl = UIPageControl()
    private let crossButton = UIButton()
    private let titleLabel = UILabel()
    private let addPhotoButton = UIButton()
    private var photoCollection: UICollectionView!
    private let lineView = UIView()
    private var buttonStackView = UIStackView()
    private let backButton = UIButton()
    private let createAdButton = UIButton()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdPhotosViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.photoCollection = createPhotoCollectionView()
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
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        photoCollection.register(HousePhotoCell.self)
        setupDataSource()
    }
    
    private func compositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in

            let itemsPerRow = 2
            let fraction: CGFloat = 1 / CGFloat(itemsPerRow)
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(fraction),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let contentInset: CGFloat = 3
            item.contentInsets = NSDirectionalEdgeInsets(
                top: contentInset,
                leading: contentInset,
                bottom: contentInset,
                trailing: contentInset
            )

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(fraction)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }

    private func createPhotoCollectionView() -> UICollectionView {
        let layout = compositionalLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }

    private func bindActions() {
        crossButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.crossDidTap)
            })
            .store(in: &cancellables)

        addPhotoButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.addPhotoDidTap)
            })
            .store(in: &cancellables)

        backButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.backDidTap)
            })
            .store(in: &cancellables)

        createAdButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.createAdDidTap)
            })
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .white

        pageControl.numberOfPages = 3
        pageControl.currentPage = 2
        pageControl.tintColor = .red
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .orange

        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "multiply",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        crossButton.configuration = config
        crossButton.imageView?.clipsToBounds = true
        crossButton.tintColor = .gray

        titleLabel.text = "Add your photos here"
        titleLabel.font = UIFont.systemFont(ofSize: 32)

        addPhotoButton.backgroundColor = .lightGray
        addPhotoButton.setTitle("Add photo", for: .normal)
        addPhotoButton.setTitleColor(.black, for: .normal)
        addPhotoButton.titleLabel?.textAlignment = .center
        addPhotoButton.layer.cornerRadius = 3
        addPhotoButton.bordered(width: 2, color: .gray)

        lineView.backgroundColor = .gray

        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 16
        buttonStackView.distribution = .fillEqually

        [backButton, createAdButton].forEach { button in
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.layer.cornerRadius = 3
            button.bordered(width: 2, color: .gray)
        }
        createAdButton.backgroundColor = .orange
        createAdButton.setTitle("Create Ad", for: .normal)
        backButton.setTitle("Back", for: .normal)
    }

    private func setupLayout() {
        addSubview(pageControl) {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(70)
            $0.height.equalTo(20)
            $0.width.equalTo(200)
        }

//        addSubview(crossButton) {
//            $0.centerY.equalTo(pageControl.snp.centerY)
//            $0.trailing.equalToSuperview().inset(16)
//            $0.size.equalTo(40)
//        }

        addSubview(titleLabel) {
            $0.top.equalTo(pageControl.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        addSubview(addPhotoButton) {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        addSubview(photoCollection) {
            $0.top.equalTo(addPhotoButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(400).priority(.low)
        }
        
        addSubview(lineView) {
            $0.top.equalTo(photoCollection.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        addSubview(buttonStackView) {
            $0.top.equalTo(lineView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(100)
        }

        backButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }

        createAdButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        buttonStackView.addArrangedSubviews([backButton, createAdButton])
    }
}

// MARK: - extension
extension AdPhotosView {
    func setupSnapshot(sections: [PhotoCollection]) {
        var snapshot = NSDiffableDataSourceSnapshot<HousePhotoSection, HousePhotoItem>()
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapshot)
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HousePhotoSection, HousePhotoItem>(
            collectionView: photoCollection,
            cellProvider: {
                collectionView, indexPath, item -> UICollectionViewCell in
                switch item {
                case let .photo(cellModel):
                    let cell: HousePhotoCell = collectionView.dedequeueReusableCell(for: indexPath)
                    cell.setupCell(cellModel)
                    cell.actionPublisher
                        .sinkWeakly(self, receiveValue: { (self, _) in
                            self.actionSubject.send(.deletePhoto(item))
                        })
                        .store(in: &cell.cancellables)
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
    struct AdPhotosPreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(AdPhotosView())
        }
    }
#endif
