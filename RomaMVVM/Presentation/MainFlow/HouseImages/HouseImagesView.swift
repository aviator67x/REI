//
//  HouseImagesView.swift
//  RomaMVVM
//
//  Created by User on 06.06.2023.
//

import UIKit
import Combine

enum HouseImagesViewAction {

}

final class HouseImagesView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<HousePhotoSection, HousePhotoItem>?
    
    // MARK: - Subviews
    private let crossButton = CrossButton()
    private var collectionView: UICollectionView!

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<HouseImagesViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
        setupCollectionView()
    }

    private func bindActions() {
    }
    
    private func setupCollectionView() {
        self.collectionView = createPhotoCollectionView()
        collectionView.register(HousePhotoCell.self)
        setupDataSource()
    }
    private func compositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in

            let itemsPerRow = 1
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
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }

    private func createPhotoCollectionView() -> UICollectionView {
        let layout = compositionalLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }

    private func setupUI() {
        backgroundColor = .white
    }

    private func setupLayout() {
        addSubview(crossButton) {
            $0.top.trailing.equalToSuperview().inset(20)
        }
    }
    
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
            collectionView: collectionView,
            cellProvider: {
                collectionView, indexPath, item -> UICollectionViewCell in
                switch item {
                case let .photo(cellModel):
                    let cell: HousePhotoCell = collectionView.dedequeueReusableCell(for: indexPath)
                    cell.setupCell(cellModel)
                    cell.actionPublisher
                        .sinkWeakly(self, receiveValue: { (self, _) in
//                            self.actionSubject.send(.deletePhoto(item))
                        })
                        .store(in: &cell.cancellables)
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
struct HouseImagesPreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(HouseImagesView())
    }
}
#endif
