//
//  LoadingFooter.swift
//  RomaMVVM
//
//  Created by User on 18.04.2023.
//

import Foundation
import UIKit
 
final class LoadingFooter: UICollectionViewCell {
    static let identifier = String(describing: LoadingFooter.self)
  private let activityView = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
    }
    
    private func setupLayout() {
        addSubview(activityView) {
            $0.center.equalToSuperview()
        }
    }
    
    func stopActivityIndicator() {
        activityView.stopAnimating()
    }
}
