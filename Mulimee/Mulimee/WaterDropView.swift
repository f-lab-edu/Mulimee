//
//  WaterDropView.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/27/24.
//

import SwiftUI

struct WaterDropView: View {
    private(set) var viewModel: WaterDropViewModel
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                Image(systemName: "drop.fill")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .scaleEffect(x: 1.1, y: 1.1)
                    .offset(y: -1)
                
                WaterWaveView(
                    progress: viewModel.waterWaveProgress,
                    waveHeight: viewModel.waveHeight,
                    offset: viewModel.offset
                )
                .fill(.teal)
                // water drop
                .overlay {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.1))
                            .frame(width: 15, height: 15)
                            .offset(x: -20)
                        
                        Circle()
                            .fill(.white.opacity(0.1))
                            .frame(width: 15, height: 15)
                            .offset(x: 40, y: 30)
                        
                        Circle()
                            .fill(.white.opacity(0.1))
                            .frame(width: 25, height: 25)
                            .offset(x: -30, y: 80)
                        
                        Circle()
                            .fill(.white.opacity(0.1))
                            .frame(width: 25, height: 25)
                            .offset(x: 50, y: 70)
                        
                        Circle()
                            .fill(.white.opacity(0.1))
                            .frame(width: 10, height: 10)
                            .offset(x: 40, y: 100)
                    }
                }
                .mask {
                    Image(systemName: "drop.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .frame(width: size.width, height: size.height, alignment: .center)
            .onAppear {
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    viewModel.startAnimation()
                }
            }
        }
        .frame(height: 450)
    }
}

#Preview {
    WaterDropView(viewModel: .init(waterWaveProgress: 0.5))
}
