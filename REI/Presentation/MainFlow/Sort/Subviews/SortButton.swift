//
//  SortButton.swift
//  REI
//
//  Created by User on 04.08.2023.
//

import UIKit

final class SortButton: UIButton {
    private let buttonName: String
    
    init(buttonName: String) {
        self.buttonName = buttonName
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 22)
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(buttonName, attributes: container)
        configuration.imagePlacement = .trailing
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18)
        configuration.imagePadding = 200
        configuration.titlePadding = 5
        
        self.configuration = configuration
        
        self.setImage(UIImage(systemName: "circle"), for: .normal)
            self.setImage(UIImage(systemName: "record.circle"), for: .selected)
        
    }
}
