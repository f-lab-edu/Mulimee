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
    
    var glassOfWater: String {
        "\(drink.numberOfGlasses)잔"
    }
    
    var liter: String {
        String(format: "%.2fL", drink.consumedLiters)
    }
    
    init(drink: Drink) {
        self.drink = drink
    }
    
    func drinkWater() {
        drink.setNumberOfGlasses(1)
        drink.setConsumedLitters(0.25)
    }
}
