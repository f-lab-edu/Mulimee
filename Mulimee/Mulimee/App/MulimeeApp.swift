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
    var body: some Scene {
        WindowGroup {
            DrinkWaterView(store: Store(initialState: DrinkWaterFeature.State()) {
                DrinkWaterFeature()
                    ._printChanges()
            })
        }
    }
}
