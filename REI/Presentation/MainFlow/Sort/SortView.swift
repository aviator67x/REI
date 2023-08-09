//
//  SortView.swift
//  REI
//
//  Created by User on 03.08.2023.
//

import Combine
import UIKit

enum SortViewAction {
    case selectedCell(SortItem)
}

final class SortView: BaseView {
    // MARK: - Subviews
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let standardButton = UIButton()
    private let addressStackView = UIStackView()
    private let addressButton = SortButton(buttonName: "Address")
    private let azButton = SortButton(buttonName: "AZ")
    private let zaButton = SortButton(buttonName: "ZA")

    private let tableView = UITableView()

    private var diffableDataSource: UITableViewDiffableDataSource<SortSection, SortItem>!

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SortViewAction, Never>()

    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        setupTable()
        setupTableLayout()
        setupUI()
        bindActions()
    }

    private func setupTable() {
        tableView.register(SortCell.self)
        tableView.register(TitleCell.self)
        setupDataSource()
        tableView.dataSource = diffableDataSource
    }

    private func bindActions() {
        tableView.didSelectRowPublisher
            .compactMap { self.diffableDataSource?.itemIdentifier(for: $0) }
            .map { SortViewAction.selectedCell($0) }
            .sinkWeakly(self) { (self, selectedCell) in
                self.actionSubject.send(selectedCell)
            }
            .store(in: &cancellables)
    }

    private func setupDataSource() {
        diffableDataSource = UITableViewDiffableDataSource<SortSection, SortItem>(
            tableView: tableView
        ) { tableView, indexPath, item in
            switch item {
            case let .title(model):
                let cell: TitleCell = tableView.dequeueReusableCell(for: indexPath)
                cell.setup(model)
                return cell
                
            case let .address(model):
                let cell: SortCell = tableView.dequeueReusableCell(for: indexPath)
                cell.setup(model)
                return cell
           
            case let .price(model):
                let cell: SortCell = tableView.dequeueReusableCell(for: indexPath)
                cell.setup(model)
                return cell
            case let .date(model):
                let cell: SortCell = tableView.dequeueReusableCell(for: indexPath)
                cell.setup(model)
                return cell
            }
        }
    }

    private func setupUI() {
        tableView.backgroundColor = .orange

        scrollView.backgroundColor = .white
        addressStackView.backgroundColor = .green
        addressButton.backgroundColor = .cyan
        contentView.backgroundColor = .gray

        azButton.backgroundColor = .green
        azButton.isHidden = true
        zaButton.isHidden = true
        zaButton.backgroundColor = .yellow
    }

    private func setupTableLayout() {
        addSubview(tableView) {
            $0.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        }
    }

    private func setupStackLayout() {
        addSubview(scrollView) {
            $0.edges.equalToSuperview()
        }

        scrollView.addSubview(contentView) {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        contentView.addSubview(addressStackView) {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        addressStackView.axis = .vertical
        addressStackView.addArrangedSubview(addressButton) {
            $0.height.equalTo(50)
        }
        addressStackView.addArrangedSubview(azButton) {
            $0.height.equalTo(50)
        }

        addressStackView.addArrangedSubview(zaButton) {
            $0.height.equalTo(50)
        }
    }

    func setupSnapShot(sections: [SortTable]) {
        var snapshot = NSDiffableDataSourceSnapshot<SortSection, SortItem>()
        for section in sections {
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.items, toSection: section.section)
        }
        diffableDataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - View constants
private enum Constant {}

#if DEBUG
    import SwiftUI
    struct SortPreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(SortView())
        }
    }
#endif
