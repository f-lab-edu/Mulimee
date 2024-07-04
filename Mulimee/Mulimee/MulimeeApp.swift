//
//  MulimeeApp.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/20/24.
//

import SwiftUI

@main
struct MulimeeApp: App {
    var body: some Scene {
        WindowGroup {
            let drink = Drink(numberOfGlasses: 0, consumedLiters: 0)
            DrinkView()
                .environment(DrinkViewModel(drink: drink))
        }
    }
}
