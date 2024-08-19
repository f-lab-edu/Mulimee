//
//  MulimeeApp.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/20/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct MulimeeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            DrinkWaterView(store: Store(initialState: DrinkWater.State()) {
                DrinkWater()
                    ._printChanges()
            })
        }
    }
}
