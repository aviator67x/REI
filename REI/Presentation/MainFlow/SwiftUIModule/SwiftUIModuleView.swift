//
//  SwiftUIModuleView.swift
//  REI
//
//  Created by User on 15.08.2023.
//

import Foundation
import Kingfisher
import SwiftUI

struct SwiftUIModuleView: View {
    @StateObject var model: SwiftUIViewModel
    var image = UIImage()

    var body: some View {
        VStack {
           
            Text(model.title)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
            Button("Save houses to Core Data", action: {
                model.saveHousesToCD()
            })
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
            Button("Retrieve houses from Core Data", action: {
                model.retrieveHousesFromCD()
            })

            if !model.data.isEmpty{
                ForEach(0..<model.data.count) { index in
                    KFImage(model.data[index])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                }
            }
            Text(model.streetName)
        }
    }
}
