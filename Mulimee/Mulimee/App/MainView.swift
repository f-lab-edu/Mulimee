//
//  MainView.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 7/9/24.
//

import SwiftUI

struct MainView: View {
    @State private var drink: Drink = Drink(repository: DrinkRepositoryService())
    @State private var isLaunching = true
    private let moveToTimer = Timer.publish(every: 2,on: .main, in: .common).autoconnect().first()
    
    var body: some View {
        if isLaunching {
            SplashView()
                .transition(.opacity)
                .onReceive(moveToTimer) { _ in
                    withAnimation {
                        isLaunching.toggle()
                    }
                }
        } else {
            DrinkView()
                .environmentObject(DrinkViewModel(drink: drink))
                .transition(.opacity)
        }
    }
}

#Preview {
    MainView()
}
