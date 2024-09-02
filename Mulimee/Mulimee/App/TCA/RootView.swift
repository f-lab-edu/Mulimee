//
//  RootView.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 8/29/24.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: StoreOf<Root>
    
    var body: some View {
        if store.isFirstLaunching {
            SplashView()
                .transition(.opacity)
                .onAppear {
                    store.send(.onAppear)
                }
        } else {
            TabView {
                DrinkWaterView(
                    store: store.scope(
                        state: \.drinkWater,
                        action: \.drinkWater
                    )
                )
                .transition(.opacity)
                .tabItem {
                    Image(systemName: "drop")
                    Text("수분")
                }
            }
            .tint(.teal)
            .font(.headline)
        }
    }
}

#Preview {
    RootView(store: .init(initialState: Root.State()) {
        Root()
    })
}
