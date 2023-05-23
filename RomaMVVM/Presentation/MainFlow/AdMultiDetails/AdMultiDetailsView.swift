//
//  AdMultiDetailsView.swift
//  RomaMVVM
//
//  Created by User on 22.05.2023.
//

import UIKit
import Combine

enum AdMultiDetailsViewAction {
    case onBackTap
case selectedItem(AdMultiDetailsItem)
}

final class AdMultiDetailsView: BaseView {
    // MARK: - Subviews
    private var crossButton = UIButton()
    private var collectionView: UICollectionView!

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdMultiDetailsViewAction, Never>()
    
    var dataSource: UICollectionViewDiffableDataSource<AdMultiDetailsSection, AdMultiDetailsItem>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        collectionView = createCollection()
        setupCollection()
        setupLayout()
        setupUI()
        bindActions()
    }
    
    private func createCollection() -> UICollectionView {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .white
        configuration.showsSeparators = false

        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collection
    }
    
    private func setupCollection() {
        collectionView.register(DetailedCell.self)
        setupDataSource()
    }

    private func bindActions() {
        crossButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.onBackTap)
            })
            .store(in: &cancellables)
        
        collectionView.didSelectItemPublisher
            .compactMap {self.dataSource?.itemIdentifier(for: $0)}
            .map {AdMultiDetailsViewAction.selectedItem($0)}
            .sink { [unowned self] in
                actionSubject.send($0)}
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .white
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "multiply",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        crossButton.configuration = config
        crossButton.imageView?.clipsToBounds = true
        crossButton.tintColor = .gray
    }

    private func setupLayout() {
        addSubview(crossButton) {
            $0.top.equalToSuperview().offset(70)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(40)
        }
        
        addSubview(collectionView) {
            $0.top.equalTo(crossButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - View constants
private enum Constant {
}

// MARK: - extensions
extension AdMultiDetailsView {
    func setupSnapShot(sections: [AdMultiDetailsCollection]) {
        var snapshot = NSDiffableDataSourceSnapshot<AdMultiDetailsSection, AdMultiDetailsItem>()
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapshot)
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<AdMultiDetailsSection, AdMultiDetailsItem>(collectionView: collectionView, cellProvider: {
            collectionView, indexPath, item -> UICollectionViewCell in
            let cell: DetailedCell = collectionView.dedequeueReusableCell(for: indexPath)
            switch item {
            case .year(let year):
                cell.setupCell(yearTitle: year)
                return cell
                
            case .garage(let garage):
                cell.setupCell(garageTitle: garage)
                return cell
                
            case .type(let type):
                cell.setupCell(typeTitle: type)
                return cell
                
            case .number(let number):
                cell.setupCell(numberTitle: number)
                return cell
            }
        })
    }
}


#if DEBUG
import SwiftUI
struct AdMultiDetailsPreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(AdMultiDetailsView())
    }
}
#endif
