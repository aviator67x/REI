//
//  Publisher+Sink.swift
//  InsideTracker
//
//  Created by Georhii Kasilov on 06.04.2022.
//

import Combine

extension Publisher {
    func sink() -> AnyCancellable {
        sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }

    func sinkWeakly<T: AnyObject>(
        _ weaklyCaptured: T,
        receiveCompletion: @escaping (T, Subscribers.Completion<Self.Failure>) -> Void = { _, _ in },
        receiveValue: @escaping (T, Self.Output) -> Void = { _, _ in }
    ) -> AnyCancellable {
        sink { [weak weaklyCaptured] result in
            guard let weaklyCaptured = weaklyCaptured else { return }

            receiveCompletion(weaklyCaptured, result)
        } receiveValue: { [weak weaklyCaptured] output in
            guard let weaklyCaptured = weaklyCaptured else { return }

            receiveValue(weaklyCaptured, output)
        }
    }
    
    func sinkWeakly<T: AnyObject>(
        _ weaklyCaptured: T,
        receiveCompletion: @escaping (T, Subscribers.Completion<Self.Failure>) -> Void = { _, _ in }
    ) -> AnyCancellable {
        sink { [weak weaklyCaptured] result in
            guard let weaklyCaptured = weaklyCaptured else { return }

            receiveCompletion(weaklyCaptured, result)
        } receiveValue: { _ in }
    }
}

extension Publisher where Failure == Never {
    func sinkWeakly<T: AnyObject>(
        _ weaklyCaptured: T,
        receiveValue: @escaping (T, Self.Output) -> Void
    ) -> AnyCancellable {
        sink { [weak weaklyCaptured] output in
            guard let weaklyCaptured = weaklyCaptured else { return }

            receiveValue(weaklyCaptured, output)
        }
    }
}
