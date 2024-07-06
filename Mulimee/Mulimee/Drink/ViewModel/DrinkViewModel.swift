//
//  DrinkViewModel.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/26/24.
//

import Foundation
import Observation

@Observable
final class DrinkViewModel {
    private(set) var drink: Drink
    private let repository: Repository
    
    var glassOfWater: String {
        "\(drink.numberOfGlasses)잔"
    }
    
    var liter: String {
        String(format: "%.2fL", drink.consumedLiters)
    }
    
    init(drink: Drink,
         repository: Repository) {
        self.drink = drink
        self.repository = repository
    }
    
    func drinkWater() {
        drink.drinkWtaer()
        repository.setDrink(with: drink.numberOfGlasses)
    }
}
