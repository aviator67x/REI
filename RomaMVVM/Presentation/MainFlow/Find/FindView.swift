//
//  FindView.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import Combine
import UIKit

enum FindViewAction {
    case collectionBottomDidReach
    case collectionTopScrollDidBegin(offset: CGPoint)
}

final class FindView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<FindSection, FindItem>?

    // MARK: - Subviews
    private lazy var stackView = UIStackView()
    private lazy var selectView = SelectView()
    private lazy var resultView = ResultView()
    private lazy var collectionView: UICollectionView = createCollectionView()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<FindViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createCollectionView() -> UICollectionView {
        let sectionProvider =
            { (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                var section: NSCollectionLayoutSection
                var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
                listConfiguration.showsSeparators = true
                section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)

                return section
            }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collection
    }

    private func setupCollectionView() {
        collectionView.register(
            PhotoCell.self,
            forCellWithReuseIdentifier: PhotoCell.reusedidentifier
        )
        setupDataSource()
    }

    private func initialSetup() {
        setupLayout(hideSelect: false)
        setupUI()
        setupCollectionView()
        bindActions()
    }

    private func bindActions() {
        collectionView.reachedBottomPublisher()
            .sink { [unowned self] in
                self.actionSubject.send(.collectionBottomDidReach)
            }
            .store(in: &cancellables)

        collectionView.contentOffsetPublisher
            .sink { [unowned self] offset in
                self.actionSubject.send(.collectionTopScrollDidBegin(offset: offset))
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .white
        stackView.axis = .vertical
        stackView.distribution = .fill
    }

    func setupLayout(hideSelect: Bool) {
        addSubview(stackView) {
            $0.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        }

        selectView.isHidden = hideSelect ? true : false

        stackView.addArrangedSubviews([selectView, resultView, collectionView])
    }
}

// MARK: - View constants
private enum Constant {}

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
                case let .photo(model):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: PhotoCell.reusedidentifier,
                        for: indexPath
                    ) as? PhotoCell else {
                        return UICollectionViewCell()
                    }
                    cell.setupCell(model)
                    return cell
                }
            }
        )
    }
}

#if DEBUG
    import SwiftUI
    struct FindPreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(FindView())
        }
    }
#endif
