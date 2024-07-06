//
//  SplashView.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 7/6/24.
//

import SwiftUI

struct SplashView: View {
    @State private var navigated: Bool = false
    private let moveToTimer = Timer.publish(every: 2,
                                            on: .main,
                                            in: .common)
                                    .autoconnect()
                                    .first()
    
    var body: some View {
        ZStack {
            LottieView()
                .ignoresSafeArea()
            
            FadeInOutView(text: "물리미", startTime: 1)
                .padding()
                .font(.title)
                .foregroundColor(.white)
        }
        .onReceive(moveToTimer) { _ in
            navigated.toggle()
        }
        .fullScreenCover(isPresented: $navigated) {
            let repository = RepositoryImpl()
            let drink = repository.fetchDrink()
            DrinkView()
                .environment(DrinkViewModel(drink: drink,
                                            repository: repository))
        }
    }
}

#Preview {
    SplashView()
}
