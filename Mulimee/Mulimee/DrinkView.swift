//
//  ContentView.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/20/24.
//

import SwiftUI

struct DrinkView: View {
    @State private(set) var viewModel: DrinkViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.glassOfWater)
                .padding()
            Button {
                viewModel.drink()
            } label: {
                Text("Drink")
            }
        }
    }
}

#Preview {
    DrinkView(viewModel: .init(waterInTake: .init(numberOfGlasses: 5, consumedLiters: 1.25)))
}
