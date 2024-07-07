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
            Color("FogMist", bundle: .main)
                .ignoresSafeArea()
            VStack {
                ZStack {
                    WaterDropView()
                        .environment(WaterDropViewModel(waterWaveProgress: viewModel.drink.waterWaveProgress))
                        .frame(height: 450)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                
                HStack(alignment: .firstTextBaseline) {
                    Text(viewModel.glassOfWater)
                        .font(.title)
                    Text(viewModel.liter)
                        .font(.callout)
                }
                .padding()
                
                Button {
                    viewModel.drinkWater()
                } label: {
                    Text("벌컥")
                        .font(.title)
                        .padding()
                        .background(.teal)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    return DrinkView()
        .environment(DrinkViewModel(drink: RepositoryImpl().fetchDrink(),
                                    repository: RepositoryImpl()))
}
