//
//  ContentView.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/20/24.
//

import SwiftUI

struct WaterInTakeView: View {
    @State private(set) var viewModel: WaterInTakeViewModel
    
    var body: some View {
        ZStack {
            Color(.cyan)
                .ignoresSafeArea()
            VStack {
                ZStack {
                    WaterDropView(viewModel: viewModel.waterDropViewModel)
                    .frame(height: 450)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                
                HStack(alignment: .bottom) {
                    Text(viewModel.glassOfWater)
                    Text(viewModel.liter)
                }
                .padding()
                Button {
                    viewModel.drink()
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
    WaterInTakeView(viewModel: .init(waterInTake: .init(numberOfGlasses: 5, consumedLiters: 1.25)))
}
