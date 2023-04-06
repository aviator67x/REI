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
                let listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
                section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)
                return section
            }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collection
    }
    
    private func setupCollectionView() {
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reusedidentifier)
        
        setupDataSource()
    }



    private func initialSetup() {
        setupLayout()
        setupUI()
        setupCollectionView()
        bindActions()
    }

    private func bindActions() {
    }

    private func setupUI() {
        backgroundColor = .white
        stackView.axis = .vertical
        stackView.distribution = .fill
    }

    private func setupLayout() {
        addSubview(stackView) {
            $0.edges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(collectionView) {
            $0.edges.equalToSuperview()
        }
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
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.items, toSection: section.section)
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
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reusedidentifier, for: indexPath) as? PhotoCell else {
                        return UICollectionViewCell()
                    }
                    cell.setupCell(model)
                    return cell
                }
            }
        )
    }
}

