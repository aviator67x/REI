//
//  SwiftUIModuleView.swift
//  REI
//
//  Created by User on 15.08.2023.
//

import Foundation

struct SwiftUIModuleView: View {
    @StateObject var model: SwiftUIViewModel

    var body: some View {
        VStack {
            Text("SwiftUI")
            Button("Button", action: {
                model.doSmth()
            })
        }
    }
}
