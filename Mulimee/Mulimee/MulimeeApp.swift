//
//  MulimeeApp.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/20/24.
//

import SwiftUI

@main
struct MulimeeApp: App {
    private let repository: Repository = RepositoryImpl()
    @State private var drink: Drink
        
    init() {
        let initialDrink = Drink(numberOfGlasses: repository.fetchDrink(), repository: repository)
        _drink = State(initialValue: initialDrink)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(drink)
        }
    }
}
