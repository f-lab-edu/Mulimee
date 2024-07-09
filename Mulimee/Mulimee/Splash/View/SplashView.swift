//
//  SplashView.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 7/6/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            LottieView()
                .ignoresSafeArea()
            
            FadeInOutView(text: "물리미", startTime: 1)
                .padding()
                .font(.title)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    SplashView()
}
