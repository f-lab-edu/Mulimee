//
//  WaterDropView.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/27/24.
//

import Combine
import SwiftUI

struct WaterDropView: View {
    @EnvironmentObject var viewModel: WaterDropViewModel
    @State private var hasAnimated = false
    
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
                        GlareCircleView(sizeConstant: 15,
                                      offset: .init(x: -20, y: 0))
                        
                        GlareCircleView(sizeConstant: 15,
                                      offset: .init(x: 40, y: 30))
                        
                        GlareCircleView(sizeConstant: 25,
                                      offset: .init(x: -30, y: 80))
                        
                        GlareCircleView(sizeConstant: 25,
                                      offset: .init(x: 50, y: 70))
                        
                        GlareCircleView(sizeConstant: 10,
                                      offset: .init(x: 40, y: 100))
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
                guard !hasAnimated else {
                    return
                }
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    viewModel.startAnimation()
                }
                hasAnimated.toggle()
            }
        }
        .frame(height: 450)
    }
}

#Preview {
    WaterDropView()
        .environmentObject(WaterDropViewModel(Just(5).eraseToAnyPublisher()))
}
