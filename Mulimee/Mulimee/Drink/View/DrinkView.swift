//
//  ContentView.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/20/24.
//

import SwiftUI

struct DrinkView: View {
    @EnvironmentObject var viewModel: DrinkViewModel
    
    var body: some View {
        ZStack {
            Color(.fogMist)
                .ignoresSafeArea()
            VStack {
                ZStack {
                    WaterDropView()
                        .environmentObject(WaterDropViewModel(viewModel.drink.numberOfGlasses))
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
                
                HStack {
                    Button {
                        viewModel.drinkWater()
                    } label: {
                        Text(viewModel.drinkButtonTitle)
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .background(viewModel.drinkButtonBackgroundColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.isDisabledDrinkButton)
                    
                    Button {
                        viewModel.reset()
                    } label: {
                        Text("초기화")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    
                }
            }
        }
    }
}

#Preview {
    DrinkView()
        .environmentObject(DrinkViewModel(drink: .init(repository: RepositoryImpl())))
}
