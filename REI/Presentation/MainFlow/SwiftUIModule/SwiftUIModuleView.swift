//
//  SwiftUIModuleView.swift
//  REI
//
//  Created by User on 15.08.2023.
//

import Foundation
import SwiftUI

struct SwiftUIModuleView: View {
    @StateObject var model: SwiftUIViewModel

    var body: some View {
        VStack {
            Text("SwiftUI")
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
            Button("Save houses to Core Data", action: {
                model.saveHousesToCD()
            })
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
            Button("Retrieve houses from Core Data", action: {
                model.retrieveHousesFromCD()
            })
        }
    }
}
