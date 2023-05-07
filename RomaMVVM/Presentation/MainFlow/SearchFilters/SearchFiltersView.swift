
//  SearchView.swift
//  RomaMVVM
//
//  Created by User on 24.03.2023.
//

import Combine
import Foundation
import UIKit

enum SearchFiltersViewAction {
    case selectedItem(SearchFiltersItem)
    case segmentControl(Int)
    case resultButtonDidTap
}

final class SearchFiltersView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<SearchFiltersSection, SearchFiltersItem>?

    // MARK: - Subviews

    private var collection: UICollectionView!
    private let resultButton = UIButton()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SearchFiltersViewAction, Never>()

    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.collection = createCollection()
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createCollection() -> UICollectionView {
        let sectionProvider =
            { [weak self] (sectionNumber: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                var section: NSCollectionLayoutSection?
                    guard let dataSource = self?.dataSource else { return nil }
                let sectionType = dataSource.snapshot().sectionIdentifiers[sectionNumber]
                    switch sectionType {
                    case .segmentControl:
                        section = self?.segmentControlSectionLayout()
                    case .distance:
                        section = self?.distanceSectionLayout()
                    case .price:
                        section = self?.priceSectionLayout()
                    case .type:
                        section = self?.typeSectionLayout()
                    case .year:
                        section = self?.yearSectionLayout()
                    case .garage:
                        section = self?.garagSectionLayout()
                    case .square:
                        section = self?.squareSectionLayout()
                    case .roomsNumber:
                        section = self?.roomsNumberSectionLayout()
                    case .backgroundItem:
                        section = self?.backgroundLayout()
                    }

                return section
            }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }

    private func segmentControlSectionLayout() -> NSCollectionLayoutSection {
        let section = sectionLayoutBuilder(section: .segmentControl)
        let footer = sectionFooterBuilder()
        section.boundarySupplementaryItems = [footer]

        return section
    }

    private func distanceSectionLayout() -> NSCollectionLayoutSection {
        let section = sectionLayoutBuilder(section: .distance)
        let header = sectionHeaderBuilder()
        let footer = sectionFooterBuilder()
        section.boundarySupplementaryItems = [header, footer]

        return section
    }

    private func priceSectionLayout() -> NSCollectionLayoutSection {
        let section = sectionLayoutBuilder(section: .price)
        let header = sectionHeaderBuilder()
        let footer = sectionFooterBuilder()
        section.boundarySupplementaryItems = [header, footer]

        return section
    }

    private func typeSectionLayout() -> NSCollectionLayoutSection {
        let section = sectionLayoutBuilder(section: .type)
        let header = sectionHeaderBuilder()
        let footer = sectionFooterBuilder()
        section.boundarySupplementaryItems = [header, footer]

        return section
    }

    private func yearSectionLayout() -> NSCollectionLayoutSection {
        let section = sectionLayoutBuilder(section: .year)
        let footer = sectionFooterBuilder()
        section.boundarySupplementaryItems = [footer]

        return section
    }

    private func garagSectionLayout() -> NSCollectionLayoutSection {
        let section = sectionLayoutBuilder(section: .garage)
        let footer = sectionFooterBuilder()
        section.boundarySupplementaryItems = [footer]

        return section
    }

    private func squareSectionLayout() -> NSCollectionLayoutSection {
        let section = sectionLayoutBuilder(section: .square)
        let header = sectionHeaderBuilder()
        let footer = sectionFooterBuilder()
        section.boundarySupplementaryItems = [header, footer]

        return section
    }

    private func roomsNumberSectionLayout() -> NSCollectionLayoutSection {
        let section = sectionLayoutBuilder(section: .roomsNumber)
        let header = sectionHeaderBuilder()
        let footer = sectionFooterBuilder()
        section.boundarySupplementaryItems = [header, footer]

        return section
    }

    private func backgroundLayout() -> NSCollectionLayoutSection {
        return sectionLayoutBuilder(section: .backgroundItem)
    }

    private func sectionLayoutBuilder(section: SearchFiltersSection) -> NSCollectionLayoutSection {
        let itemWidthDimension: NSCollectionLayoutDimension
        let groupHeight: CGFloat
        let groupLeadingInset: CGFloat
        let groupInterItemSpacing: NSCollectionLayoutSpacing?
        switch section {
        case .segmentControl:
            itemWidthDimension = .fractionalWidth(1)
            groupHeight = 70
            groupLeadingInset = 0
            groupInterItemSpacing = nil
        case .distance, .roomsNumber, .type:
            itemWidthDimension = .estimated(1)
            groupHeight = 36
            groupLeadingInset = 35
            groupInterItemSpacing = .fixed(6)
        case .price, .year, .garage, .square:
            itemWidthDimension = .fractionalWidth(1)
            groupHeight = 60
            groupLeadingInset = 0
            groupInterItemSpacing = nil
        case .backgroundItem:
            itemWidthDimension = .fractionalWidth(1)
            groupHeight = 200
            groupLeadingInset = 0
            groupInterItemSpacing = nil
        }

        let itemSize = NSCollectionLayoutSize(
            widthDimension: itemWidthDimension,
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(groupHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: groupLeadingInset, bottom: 0, trailing: 0)
        group.interItemSpacing = groupInterItemSpacing

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))

        return section
    }

    private func sectionHeaderBuilder() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: "header",
            alignment: .top
        )

        return sectionHeader
    }

    private func sectionFooterBuilder() -> NSCollectionLayoutBoundarySupplementaryItem {
        let backgroundFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(4)
        )
        let backgroundFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: backgroundFooterSize,
            elementKind: "BackgroundFooter",
            alignment: .bottom
        )

        return backgroundFooter
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        setupCollection()
        bindActions()
    }

    private func bindActions() {
        collection.didSelectItemPublisher
            .compactMap { self.dataSource?.itemIdentifier(for: $0) }
            .map { SearchFiltersViewAction.selectedItem($0) }
            .sink { [unowned self] in
                actionSubject.send($0)
            }
            .store(in: &cancellables)
        
        resultButton.tapPublisher
            .sink { _ in
                self.actionSubject.send(.resultButtonDidTap)
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .systemTeal
        resultButton.backgroundColor = .systemBlue
        resultButton.setTitle("Result", for: .normal)
        resultButton.setTitleColor(.white, for: .normal)
        resultButton.titleLabel?.textAlignment = .center
    }

    private func setupCollection() {
        collection.register(
            BackgroundFooterView.self,
            forSupplementaryViewOfKind: "BackgroundFooter",
            withReuseIdentifier: "BackgroundFooter"
        )
        collection.register(
            HeaderView.self,
            forSupplementaryViewOfKind: "header",
            withReuseIdentifier: "Header"
        )
        collection.register(SegmentControlCell.self)
        collection.register(DistanceCell.self)
        collection.register(PriceCell.self)
        collection.register(TypeCell.self)
        collection.register(UniversalCell.self)
        collection.register(SquareCell.self)
        collection.register(RoomsNumberCell.self)
        collection.register(TypeCell.self)
        collection.register(BackgroundCell.self)
        
        setupDataSource()
    }

    private func setupLayout() {
        addSubview(collection) {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        addSubview(resultButton) {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(30)
        }
    }
}

// MARK: - View constants
private enum Constant {}

#if DEBUG
    import SwiftUI
    struct SearchPreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(SearchFiltersView())
        }
    }
#endif

// MARK: - extension
extension SearchFiltersView {
    func setupSnapshot(sections: [SearchFiltersCollection]) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchFiltersSection, SearchFiltersItem>()
        for section in sections {
            snapshot.appendSections([section.sections])
            snapshot.appendItems(section.items, toSection: section.sections)
        }
        dataSource?.apply(snapshot)
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SearchFiltersSection, SearchFiltersItem>(
            collectionView: collection,
            cellProvider: { [unowned self] _, indexPath, item -> UICollectionViewCell in
                switch item {
                case .segmentControl:
                    let cell: SegmentControlCell = collection.dedequeueReusableCell(for: indexPath)
                    cell.segmentPublisher
                        .sinkWeakly(self, receiveValue: { (self, value) in
                            if let value = value {
                                self.actionSubject.send(.segmentControl(value))
                            }                           
                        })
                        .store(in: &cancellables)
                    return cell
                case let .distance(km):
                    let cell: DistanceCell = collection.dedequeueReusableCell(for: indexPath)
                    cell.setupCell(with: km)
                    
                    return cell
                case var .price(model):
                    let cell: PriceCell = collection.dedequeueReusableCell(for: indexPath)
                    cell.setupCell(with: model)
                    
                    return cell
                case let .type(title):
                    let cell: TypeCell = collection.dedequeueReusableCell(for: indexPath)
                    cell.setupCell(with: title)
                    return cell
                case .year:
                    let cell: UniversalCell = collection.dedequeueReusableCell(for: indexPath)
                    let model = UniversalCellModel(
                        image: UIImage(systemName: "square.split.bottomrightquarter"),
                        itemText: "Period of building",
                        infoText: "since 1875"
                    )
                    cell.setupCell(model: model)
                    return cell
                case .garage:
                    let cell: UniversalCell = collection.dedequeueReusableCell(for: indexPath)
                    let model = UniversalCellModel(
                        image: UIImage(systemName: "car"),
                        itemText: "Garage",
                        infoText: "type of parking slot"
                    )
                    cell.setupCell(model: model)
                    return cell
                case let .square(model):
                    let cell: SquareCell = collection.dedequeueReusableCell(for: indexPath)
                    cell.setupCell(with: model)
                    
                    return cell
                case let .roomsNumber(title):
                    let cell: RoomsNumberCell = collection.dedequeueReusableCell(for: indexPath)
                    cell.setupCell(with: title)
                    
                    return cell
                case .backgroundItem:
                    let cell: BackgroundCell = collection.dedequeueReusableCell(for: indexPath)
                    
                    return cell
                }
            }
        )
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case "header":
                guard let header: HeaderView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: "header",
                    withReuseIdentifier: "Header",
                    for: indexPath
                ) as? HeaderView else {
                    return nil
                }
                if #available(iOS 15.0, *) {
                    guard
                        let section = self.dataSource?.sectionIdentifier(for: indexPath.section),
                        let title = section.headerTitle,
                        let imageName = section.headerImageName
                    else {
                        return nil
                    }
                    header.setupUI(text: title, imageName: imageName)
                    return header
                    
                } else {
                    // Fallback on earlier versions
                    return nil
                }
                
            case "BackgroundFooter":
                guard let footer: BackgroundFooterView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: "BackgroundFooter",
                    withReuseIdentifier: "BackgroundFooter",
                    for: indexPath
                ) as? BackgroundFooterView else {
                    return nil
                }
                
                return footer                
            default:
                return nil
            }
        }
    }
}
