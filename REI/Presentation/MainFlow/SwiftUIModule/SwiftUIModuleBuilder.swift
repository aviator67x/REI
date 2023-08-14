//
//  SwiftUIModuleBuilder.swift
//  REI
//
//  Created by User on 14.08.2023.
//

import UIKit
import Combine
import SwiftUI

enum SwiftUITransition: Transition {
    
}

final class SwiftUIModuleBuilder {
    class func build(container: AppContainer) -> Module<SwiftUITransition, UIViewController> {
        let viewModel = SwiftUIViewModel()
        let viewController = UIHostingController(rootView: SwiftUIModuleView())
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
    
    struct SwiftUIModuleView: View {
        var body: some View {
            EmptyView()
        }
    }
}
