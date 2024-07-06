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
            let drink = RepositoryImpl().fetchDrink()
            DrinkView()
                .environment(DrinkViewModel(drink: drink))
        }
    }
}
