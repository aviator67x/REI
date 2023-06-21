//
//  Publisher+WithLatestFrom.swift
//  InsideTracker
//
//  Created by Georhii Kasilov on 06.04.2022.
//

import Combine

extension Publisher {
    func withLatestFrom<Other: Publisher>(
        _ other: Other
    ) -> AnyPublisher<Other.Output, Other.Failure>
    where Failure == Other.Failure {
        other
            .map { second in map { _ in second } }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    func withLatestFrom<Other: Publisher, Transformed>(
        _ other: Other,
        _ selector: @escaping (Output, Other.Output) -> Transformed
    ) -> AnyPublisher<Transformed, Other.Failure>
    where Failure == Other.Failure {
        other
            .map { second in map { first in selector(first, second) } }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}
