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
    
    var body: some Scene {
        WindowGroup {
            MainView(drink: Drink(repository: repository))
        }
    }
}
