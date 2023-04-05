//
//  FindView.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import UIKit
import Combine

enum FindViewAction {

}

final class FindView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<FindSection, FindItem>?
    
    // MARK: - Subviews
    private lazy var stackView = UIStackView()
    private lazy var collectionView: UICollectionView = createCollectionView()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<FindViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCollectionView() -> UICollectionView {
        let sectionProvider =
            { (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                var section: NSCollectionLayoutSection
                var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
                section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)
                return section
            }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collection
    }
    
    private func setupCollectionView() {
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PlainCell.identifier)
        
        setupDataSource()
    }



    private func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }

    private func bindActions() {
    }

    private func setupUI() {
        backgroundColor = .white
    }

    private func setupLayout() {
    }
}

// MARK: - View constants
private enum Constant {
}

#if DEBUG
import SwiftUI
struct FindPreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(FindView())
    }
}
#endif

// MARK: - extension
extension FindView {
    func setupSnapShot(sections: [FindCollection]) {
        var snapshot = NSDiffableDataSourceSnapshot<FindSection, FindItem>()
        for section in sections {
//            snapshot.appendSections([section.section])
//            snapshot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapshot)
    }

    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<FindSection, FindItem>(
            collectionView: collectionView,
            cellProvider: {
                collectionView, indexPath, item -> UICollectionViewCell in
                switch item {
                case .photo(let model):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: PhotoCell.identifier,
                        for: indexPath
                    ) as? PlainCell else {
                        return UICollectionViewCell()
                    }
//                    cell.setupCell(model)
                    return cell
                }
            }
        )
    }
}

