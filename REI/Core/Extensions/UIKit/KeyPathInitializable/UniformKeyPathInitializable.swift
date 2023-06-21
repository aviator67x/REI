//
//  UniformKeyPathInitializable.swift
//  hwyhaul-driver
//
//  Created by Georhii Kasilov on 13.03.2021.
//

public protocol UniformKeyPathInitializable: ExpressibleByDictionaryLiteral {
    init()
}

public extension UniformKeyPathInitializable {
    init(dictionaryLiteral elements: (WritableKeyPath<Self, Self.Value>, Self.Value)...) {
        self.init()
        elements.forEach { self[keyPath: $0.0] = $0.1 }
    }
}
