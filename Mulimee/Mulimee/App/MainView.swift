//
//  MainView.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 7/9/24.
//

import SwiftUI

struct MainView: View {
    private var drink: Drink
    @State private var isLaunching = true
    private let moveToTimer = Timer.publish(every: 2,on: .main, in: .common).autoconnect().first()
    
    init(drink: Drink) {
        self.drink = drink
    }
    
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
                .onChange(of: scenePhase) {
                    drink.reload()
                }
        }
    }
}

#Preview {
    MainView(drink: .init(repository: RepositoryImpl()))
}
