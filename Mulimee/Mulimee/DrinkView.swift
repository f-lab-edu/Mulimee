//
//  ContentView.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/20/24.
//

import SwiftUI

struct DrinkView: View {
    @Environment(DrinkViewModel.self) private var viewModel
    
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
    let viewModel = DrinkViewModel(waterInTake: .init(numberOfGlasses: 5, consumedLiters: 1.25))
    return DrinkView()
        .environment(viewModel)
}
