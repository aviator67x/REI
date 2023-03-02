//
//  Publisher+Unwrap.swift
//  InsideTracker
//
//  Created by Georhii Kasilov on 06.04.2022.
//

import Combine
import Foundation

protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? { self }
}

extension Publishers {
    struct Unwrapped<Upstream>: Publisher where Upstream: Publisher, Upstream.Output: OptionalType {
        typealias Output = Upstream.Output.Wrapped
        typealias Failure = Upstream.Failure
        
        let upstream: AnyPublisher<Output, Failure>
        
        init(upstream: Upstream) {
            self.upstream = upstream
                .flatMap { `optional` -> AnyPublisher<Output, Failure> in
                    guard let upstream = `optional`.value else {
                        return Empty().eraseToAnyPublisher()
                    }
                    
                    return Result.Publisher(upstream).eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        }
        
        func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
            upstream.receive(subscriber: subscriber)
        }
    }
}

extension Publisher where Output: OptionalType {
    func unwrap() -> Publishers.Unwrapped<Self> { Publishers.Unwrapped(upstream: self) }
}
