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
            Color("FogMist", bundle: .main)
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
                        Text("마시기")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .background(.teal)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
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
