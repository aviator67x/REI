//
//  FindView.swift
//  RomaMVVM
//
//  Created by User on 05.04.2023.
//

import Combine
import UIKit

enum SearchResultsViewAction {
    case collectionBottomDidReach
    case fromSelectViewTransition(SelectViewAction)
}

final class SearchResultsView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<SearchResultsSection, SearchResultsItem>?

    // MARK: - Subviews
    private lazy var stackView = UIStackView()
    private lazy var selectView = SelectView()
    private lazy var resultView = SearchResultView()
    private lazy var collectionView: UICollectionView = createCollectionView()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SearchResultsViewAction, Never>()

    private lazy var stackViewTopConstraint = stackView.topAnchor.constraint(
        equalTo: self.safeAreaLayoutGuide.topAnchor,
        constant: 0
    )

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
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.reusedidentifier)
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.reusedidentifier)
        collectionView.register(MapCell.self, forCellWithReuseIdentifier: MapCell.reusedidentifier)

        setupDataSource()
    }

    private func initialSetup() {
        setupLayout()
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
                let yOffset = offset.y
                let selectViewHeight = selectView.bounds.height
                if yOffset >= selectViewHeight {
                    stackViewTopConstraint.constant = -selectViewHeight
                } else {
                    stackViewTopConstraint.constant = -yOffset
                }
            }
            .store(in: &cancellables)
        
        selectView.actionPublisher
            .sinkWeakly(self, receiveValue: {(self, transition) in
                self.actionSubject.send(.fromSelectViewTransition(transition))
            })
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .white
        stackView.axis = .vertical
        stackView.distribution = .fill
    }

    private func setupLayout() {
        stackView.addArrangedSubview(selectView)
        stackView.addArrangedSubview(resultView)
        stackView.addArrangedSubview(collectionView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackViewTopConstraint,
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
}

// MARK: - View constants
private enum Constant {}

// MARK: - extension
extension SearchResultsView {
    func makeSelectView(isVisible: Bool) {
        selectView.isHidden = !isVisible
    }
    
    func updateSearchResultView(with data: SearchResultViewModel) {
        resultView.setup(with: data)
    }
    
    func setupSnapShot(sections: [SearchResultsCollection]) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchResultsSection, SearchResultsItem>()
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapshot)
    }

    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SearchResultsSection, SearchResultsItem>(
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
                case let .main(model):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MainCell.reusedidentifier,
                        for: indexPath
                    ) as? MainCell else {
                        return UICollectionViewCell()
                    }
                    cell.setupCell(model)
                    return cell
                case let .list(model):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ListCell.reusedidentifier,
                        for: indexPath
                    ) as? ListCell else {
                        return UICollectionViewCell()
                    }
                    cell.setupCell(model)
                    return cell
                case .map:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MapCell.reusedidentifier,
                        for: indexPath
                    ) as? MapCell else {
                        return UICollectionViewCell()
                    }
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
            ViewRepresentable(SearchResultsView())
        }
    }
#endif
