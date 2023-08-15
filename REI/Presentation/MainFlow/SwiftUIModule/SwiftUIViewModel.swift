//
//  SwiftUIViewModel.swift
//  REI
//
//  Created by User on 14.08.2023.
//

import Combine
import SwiftUI

final class SwiftUIViewModel: BaseViewModel, ObservableObject {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SwiftUITransition, Never>()
    
    @Published var title: String = "Initial title"
    
    override init() {

        super.init()
    }
    
    func doSmth() {
        print("I din somth")
    }
    
}
