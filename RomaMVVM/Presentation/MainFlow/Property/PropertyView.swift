//
//  PropertyView.swift
//  RomaMVVM
//
//  Created by User on 06.03.2023.
//

import Combine
import Kingfisher
import UIKit

enum PropertyViewAction {
    case filterDidTap
}

final class PropertyView: BaseView {
    // MARK: - Subviews
    private let imageView = UIImageView()
    private let idLabel = UILabel()
    private let filterButton = BaseButton(buttonState: .filter)

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<PropertyViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }

    private func bindActions() {
        filterButton.tapPublisher
            .sink { [unowned self] in
                actionSubject.send(.filterDidTap)
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .white
        idLabel.textAlignment = .center
    }

    private func setupLayout() {
        addSubview(imageView, withEdgeInsets: UIEdgeInsets(top: 100, left: 20, bottom: 100, right: 20))
        addSubview(idLabel) { _ in
            idLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
            idLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 30).isActive = true
            idLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: 20).isActive = true
            idLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        addSubview(filterButton) { _ in
            filterButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
            filterButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
            filterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }

    func setImage() {
        let url =
            URL(
                string: "https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png"
            )
        imageView.kf.setImage(with: url, options: [.forceRefresh]) { respose in
            switch respose {
            case let .success(data):
                print(data)
            case let .failure(error):
                print(error.errorDescription ?? "")
            }
        }

        imageView.backgroundColor = .cyan
    }
    
    func setLabel(id: String) {
        idLabel.text = id
    }
}

// MARK: - View constants
private enum Constant {}

#if DEBUG
    import SwiftUI
    struct PropertyPreview: PreviewProvider {
        static var previews: some View {
            ViewRepresentable(PropertyView())
        }
    }
#endif
