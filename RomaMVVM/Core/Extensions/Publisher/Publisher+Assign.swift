//
//  Publisher+Assign.swift
//  InsideTracker
//
//  Created by Georhii Kasilov on 06.04.2022.
//

import Combine
import Foundation

extension Publisher where Failure == Never {
    func assignWeakly<Root: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<Root, Output?>,
        on root: Root
    ) -> AnyCancellable {
        sink { [weak root] in root?[keyPath: keyPath] = $0 }
    }

    func assignWeakly<Root: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<Root, Output>,
        on root: Root
    ) -> AnyCancellable {
        sink { [weak root] in root?[keyPath: keyPath] = $0 }
    }
}
