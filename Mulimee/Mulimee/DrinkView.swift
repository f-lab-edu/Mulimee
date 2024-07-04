//
//  ContentView.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/20/24.
//

import SwiftUI

struct DrinkView: View {
    @Environment(DrinkViewModel.self) var viewModel
    
    var body: some View {
        ZStack {
            Color(.cyan)
                .ignoresSafeArea()
            VStack {
                ZStack {
                    WaterDropView()
                        .environment(WaterDropViewModel(waterWaveProgress: viewModel.drink.waterWaveProgress))
                        .frame(height: 450)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                
                HStack(alignment: .bottom) {
                    Text(viewModel.glassOfWater)
                    Text(viewModel.liter)
                }
                .padding()
                Button {
                    viewModel.drinkWater()
                } label: {
                    Text("Drink!")
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    DrinkView()
        .environment(DrinkViewModel(drink: .init(numberOfGlasses: 5, consumedLiters: 1.25)))
}
