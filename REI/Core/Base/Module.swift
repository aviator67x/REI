//
//  Module.swift
//  REI
//
//  Created by user on 14.12.2021.
//

import UIKit
import Combine

protocol Transition {}

struct Module<T: Transition, V: UIViewController> {
    let viewController: V
    let transitionPublisher: AnyPublisher<T, Never>
}
