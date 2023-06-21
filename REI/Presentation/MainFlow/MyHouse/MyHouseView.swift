//
//  MyHouseView.swift
//  RomaMVVM
//
//  Created by User on 27.04.2023.
//

import Combine
import UIKit

enum MyHouseViewAction {
    case buttonDidTap
    case swipedItem(MyHouseItem)
    case selectedItem(MyHouseItem)
}

final class MyHouseView: BaseView {
    var dataSource: UICollectionViewDiffableDataSource<MyHouseSection, MyHouseItem>?
    
    // MARK: - Subviews
    private let backgroundView = UIView()
    private let imageView = UIImageView()
    private let questionLabel = UILabel()
    private let textLabel = UILabel()
    private let button = UIButton()
    private lazy var collectionView: UICollectionView = createCollectionView()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MyHouseViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        setupCollectionView()
        setupLayout()
        setupUI()
        bindActions()
    }

    private func bindActions() {
        button.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.buttonDidTap)
            })
            .store(in: &cancellables)
        
        collectionView.didSelectItemPublisher
            .compactMap {self.dataSource?.itemIdentifier(for: $0)}
            .map {MyHouseViewAction.selectedItem($0)}
            .sink { [unowned self] in
                actionSubject.send($0)}
            .store(in: &cancellables)
    }
    
    private func createCollectionView() -> UICollectionView {
        let sectionProvider =
            { (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                var section: NSCollectionLayoutSection
                var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
                listConfiguration.showsSeparators = true

                listConfiguration.trailingSwipeActionsConfigurationProvider = { indexPath in
                    let del = UIContextualAction(style: .destructive, title: "Delete") {
                        [weak self] _, _, _ in
                        if let item = self?.dataSource?.itemIdentifier(for: indexPath) {
                            self?.actionSubject.send(.swipedItem(item))
                        }
                    }
                    return UISwipeActionsConfiguration(actions: [del])
                }
                section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)

                return section
            }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collection
    }

    private func setupCollectionView() {
        collectionView.register(FavouriteCell.self)
        collectionView.backgroundView = backgroundView
        setupDataSource()
    }


    private func setupUI() {
        backgroundColor = .white
        imageView.image = UIImage(named: "house")
        imageView.rounded(50)

        let quote = "Want to know the market price of your property?"
        let text = "Add the house to your accout and get updated about the current value of your property"
        questionLabel.text = quote
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)

        textLabel.text = text
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 18)

        button.backgroundColor = .systemBlue
        button.setTitle("Create an advertisement", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 3
    }

    private func setupLayout() {
        addSubview(collectionView) {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        backgroundView.addSubview(imageView) {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(250)
            $0.size.equalTo(100)
        }
        backgroundView.addSubview(questionLabel) {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        backgroundView.addSubview(textLabel) {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(questionLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        backgroundView.addSubview(button) {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(textLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MyHouseSection, MyHouseItem>(
            collectionView: collectionView,
            cellProvider: {
                collectionView, indexPath, item -> UICollectionViewCell in
                switch item {
                case let .photo(model):
                    let cell: FavouriteCell = collectionView.dedequeueReusableCell(for: indexPath)
                    cell.setupCell(model)
                    return cell
                }
            }
        )
    }
}

// MARK: - extension
extension MyHouseView {
    func setupSnapShot(sections: [MyHouseCollection]) {
        var snapshot = NSDiffableDataSourceSnapshot<MyHouseSection, MyHouseItem>()
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapshot)
    }
}

// MARK: - View constants
private enum Constant {}

#if DEBUG
    import SwiftUI
    struct MyHousePreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(MyHouseView())
        }
    }
#endif
