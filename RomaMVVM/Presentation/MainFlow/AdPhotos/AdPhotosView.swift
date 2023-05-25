//
//  AdPhotosView.swift
//  RomaMVVM
//
//  Created by User on 25.05.2023.
//

import UIKit
import Combine

enum AdPhotosViewAction {
    case crossDidTap
    case backDidTap
    case addPhotoDidTap
}

final class AdPhotosView: BaseView {
    // MARK: - Subviews
    private let pageControl = UIPageControl()
    private let crossButton = UIButton()
    private let titleLabel = UILabel()
    private let addPhotoButton = UIButton()
    private let lineView = UIView()
    private let backButton = UIButton()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdPhotosViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }

    private func bindActions() {
        crossButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.crossDidTap)
            })
            .store(in: &cancellables)
        
        addPhotoButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.addPhotoDidTap)
            })
            .store(in: &cancellables)
        
        backButton.tapPublisher
            .sinkWeakly(self, receiveValue: { (self, _) in
                self.actionSubject.send(.crossDidTap)
            })
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .white
        
        pageControl.numberOfPages = 3
        pageControl.currentPage = 2
        pageControl.tintColor = .red
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .orange

        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "multiply",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        crossButton.configuration = config
        crossButton.imageView?.clipsToBounds = true
        crossButton.tintColor = .gray

        titleLabel.text = "Add your photos here"
        titleLabel.font = UIFont.systemFont(ofSize: 32)
        
        addPhotoButton.backgroundColor = .lightGray
        addPhotoButton.setTitle("Add photo", for: .normal)
        addPhotoButton.setTitleColor(.black, for: .normal)
        addPhotoButton.titleLabel?.textAlignment = .center
        addPhotoButton.layer.cornerRadius = 3
        addPhotoButton.bordered(width: 2, color: .gray)
        
        lineView.backgroundColor = .gray

        backButton.backgroundColor = .orange
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.titleLabel?.textAlignment = .center
        backButton.layer.cornerRadius = 3
        backButton.bordered(width: 2, color: .gray)

    }

    private func setupLayout() {
        addSubview(pageControl) {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(70)
            $0.height.equalTo(20)
            $0.width.equalTo(200)
        }
        
        addSubview(crossButton) {
            $0.centerY.equalTo(pageControl.snp.centerY)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(40)
        }

        addSubview(titleLabel) {
            $0.top.equalTo(crossButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(addPhotoButton) {
            $0.top.equalTo(titleLabel.snp.bottom).offset(100)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        addSubview(backButton) {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(100)
        }
        
        addSubview(lineView) {
            $0.bottom.equalTo(backButton.snp.top).offset(-20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
}

// MARK: - View constants
private enum Constant {
}

#if DEBUG
import SwiftUI
struct AdPhotosPreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(AdPhotosView())
    }
}
#endif
