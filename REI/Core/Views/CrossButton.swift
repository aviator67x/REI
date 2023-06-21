//
//  CrossButton.swift
//  RomaMVVM
//
//  Created by User on 06.06.2023.
//

import Foundation
import UIKit

final class CrossButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        initialSetup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialSetup() {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "multiply",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )
        self.configuration = config
        self.imageView?.clipsToBounds = true
        self.tintColor = .gray
    }
}
