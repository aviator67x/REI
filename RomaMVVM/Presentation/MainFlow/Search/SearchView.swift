
//  SearchView.swift
//  RomaMVVM
//
//  Created by User on 24.03.2023.
//

import Combine
import Foundation
import UIKit

enum SearchViewAction {
    case selectedItem(SearchItem)
    case segmentControl(Int)
}

final class SearchView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<SearchSection, SearchItem>?

    // MARK: - Subviews

    private var collection: UICollectionView!
    private let resultLabel = UILabel()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SearchViewAction, Never>()

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
                let sectionType = SearchSection.allCases
                switch sectionType[sectionNumber] {
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
        return sectionLayoutBuilder(section: .segmentControl)
    }

    private func distanceSectionLayout() -> NSCollectionLayoutSection {
        let section = sectionLayoutBuilder(section: .distance)
        let header = sectionHeaderBuilder()
        section.boundarySupplementaryItems.append(header)

        return section
    }

    private func priceSectionLayout() -> NSCollectionLayoutSection {
        let section = sectionLayoutBuilder(section: .price)
        let header = sectionHeaderBuilder()
        section.boundarySupplementaryItems.append(header)

        return section
    }

    private func typeSectionLayout() -> NSCollectionLayoutSection {
        let section = sectionLayoutBuilder(section: .type)
        let header = sectionHeaderBuilder()
        section.boundarySupplementaryItems.append(header)

        return section
    }

    private func yearSectionLayout() -> NSCollectionLayoutSection {
        return sectionLayoutBuilder(section: .year)
    }

    private func garagSectionLayout() -> NSCollectionLayoutSection {
        return sectionLayoutBuilder(section: .garage)
    }

    private func squareSectionLayout() -> NSCollectionLayoutSection {
        let section = sectionLayoutBuilder(section: .square)
        let header = sectionHeaderBuilder()
        section.boundarySupplementaryItems.append(header)

        return section
    }

    private func roomsNumberSectionLayout() -> NSCollectionLayoutSection {
        let section = sectionLayoutBuilder(section: .roomsNumber)
        let header = sectionHeaderBuilder()
        section.boundarySupplementaryItems.append(header)

        return section
    }

    private func backgroundLayout() -> NSCollectionLayoutSection {
        return sectionLayoutBuilder(section: .backgroundItem)
    }

    private func sectionLayoutBuilder(section: SearchSection) -> NSCollectionLayoutSection {
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

        let backgroundFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(4)
        )
        let backgroundFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: backgroundFooterSize,
            elementKind: "BackgroundFooter",
            alignment: .bottom
        )
        section.boundarySupplementaryItems = [backgroundFooter]

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

    private func initialSetup() {
        setupLayout()
        setupUI()
        setupCollection()
        bindActions()
    }

    private func bindActions() {
        collection.didSelectItemPublisher
            .compactMap { self.dataSource?.itemIdentifier(for: $0) }
            .map { SearchViewAction.selectedItem($0) }
            .sink { [unowned self] in
                actionSubject.send($0)
                print($0)
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .systemTeal
        resultLabel.backgroundColor = .systemBlue
        resultLabel.text = "Result"
        resultLabel.textColor = .white
        resultLabel.textAlignment = .center
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
        collection.register(SegmentControlCell.self, forCellWithReuseIdentifier: SegmentControlCell.reusedidentifier)
        collection.register(DistanceCell.self, forCellWithReuseIdentifier: DistanceCell.reusedidentifier)
        collection.register(PriceCell.self, forCellWithReuseIdentifier: PriceCell.reusedidentifier)
        collection.register(TypeCell.self, forCellWithReuseIdentifier: TypeCell.reusedidentifier)
        collection.register(UniversalCell.self, forCellWithReuseIdentifier: UniversalCell.reusedidentifier)
        collection.register(SquareCell.self, forCellWithReuseIdentifier: SquareCell.reusedidentifier)
        collection.register(RoomsNumberCell.self, forCellWithReuseIdentifier: RoomsNumberCell.reusedidentifier)
        collection.register(TypeCell.self, forCellWithReuseIdentifier: TypeCell.reusedidentifier)
        collection.register(BackgroundCell.self, forCellWithReuseIdentifier: BackgroundCell.reusedidentifier)
        setupDataSource()
    }

    private func setupLayout() {
        addSubview(collection) {
            $0.edges.equalToSuperview()
        }

        addSubview(resultLabel) {
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
            ViewRepresentable(SearchView())
        }
    }
#endif

// MARK: - extension
extension SearchView {
    func setupSnapshot(sections: [SearchCollection]) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchSection, SearchItem>()
        for section in sections {
            snapshot.appendSections([section.sections])
            snapshot.appendItems(section.items, toSection: section.sections)
        }
        dataSource?.apply(snapshot)
    }

    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SearchSection, SearchItem>(
            collectionView: collection,
            cellProvider: { [unowned self] _, indexPath, item -> UICollectionViewCell in
                switch item {
                case .segmentControl:
                    guard let cell = collection.dequeueReusableCell(
                        withReuseIdentifier: SegmentControlCell.reusedidentifier,
                        for: indexPath
                    ) as? SegmentControlCell else { return UICollectionViewCell() }
                    cell.segmentPublisher
                        .sinkWeakly(self, receiveValue: { (self, value) in
                            self.actionSubject.send(.segmentControl(value))
                        })
                        .store(in: &cancellables)
                    return cell
                case let .distance(km):
                    guard let cell = collection.dequeueReusableCell(
                        withReuseIdentifier: DistanceCell.reusedidentifier,
                        for: indexPath
                    ) as? DistanceCell else { return UICollectionViewCell() }
                    cell.setupCell(with: km)

                    return cell
                case var .price(model):
                    guard let cell = collection.dequeueReusableCell(
                        withReuseIdentifier: PriceCell.reusedidentifier,
                        for: indexPath
                    ) as? PriceCell else { return UICollectionViewCell() }
                    cell.setupCell(with: model)

                    return cell
                case let .type(title):
                    guard let cell = collection.dequeueReusableCell(
                        withReuseIdentifier: TypeCell.reusedidentifier,
                        for: indexPath
                    ) as? TypeCell else { return UICollectionViewCell() }
                    cell.setupCell(with: title)
                    return cell
                case .year:
                    guard let cell = collection.dequeueReusableCell(
                        withReuseIdentifier: UniversalCell.reusedidentifier,
                        for: indexPath
                    ) as? UniversalCell else { return UICollectionViewCell() }
                    let model = UniversalCellModel(
                        image: UIImage(systemName: "square.split.bottomrightquarter"),
                        itemText: "Period of building",
                        infoText: "since 1875"
                    )
                    cell.setupCell(model: model)
                    return cell
                case .garage:
                    guard let cell = collection.dequeueReusableCell(
                        withReuseIdentifier: UniversalCell.reusedidentifier,
                        for: indexPath
                    ) as? UniversalCell else { return UICollectionViewCell() }
                    let model = UniversalCellModel(
                        image: UIImage(systemName: "car"),
                        itemText: "Garage",
                        infoText: "type of parking slot"
                    )
                    cell.setupCell(model: model)
                    return cell
                case let .square(model):
                    guard let cell = collection.dequeueReusableCell(
                        withReuseIdentifier: SquareCell.reusedidentifier,
                        for: indexPath
                    ) as? SquareCell else { return UICollectionViewCell() }
                    cell.setupCell(with: model)

                    return cell
                case let .roomsNumber(title):
                    guard let cell = collection.dequeueReusableCell(
                        withReuseIdentifier: RoomsNumberCell.reusedidentifier,
                        for: indexPath
                    ) as? RoomsNumberCell else { return UICollectionViewCell() }
                    cell.setupCell(with: title)

                    return cell
                case .backgroundItem:
                    guard let cell = collection.dequeueReusableCell(
                        withReuseIdentifier: BackgroundCell.reusedidentifier,
                        for: indexPath
                    ) as? BackgroundCell else { return UICollectionViewCell() }

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
                ) as? HeaderView else { return UICollectionReusableView() }

                let sectionType = SearchSection.allCases
                switch sectionType[indexPath.section] {
                case .segmentControl, .year, .garage, .backgroundItem:
                   break
                case .distance:
                    header.setupUI(text: "Distance", imageName: "plus")
                case .price:
                    header.setupUI(text: "Price category", imageName: "eurosign")
                case .type:
                    header.setupUI(text: "Type of property", imageName: "homekit")
                case .square:
                    header.setupUI(text: "Square of the property in sqm", imageName: "light.panel")
                case .roomsNumber:
                    header.setupUI(text: "Number of rooms", imageName: "door.right.hand.open")
                }

                return header
            case "BackgroundFooter":
                guard let footer: BackgroundFooterView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: "BackgroundFooter",
                    withReuseIdentifier: "BackgroundFooter",
                    for: indexPath
                ) as? BackgroundFooterView else { return UICollectionReusableView() }

                return footer
            default:
                return UICollectionReusableView()
            }
        }
    }
}