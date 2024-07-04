//
//  DrinkViewModel.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/26/24.
//

import Foundation
import Observation

protocol DrinkViewModelProtocol {
    var glassOfWater: String { get }
    var liter: String { get }
    
    func drink()
}

@Observable
final class DrinkViewModel {
    private(set) var waterInTake: Drink
    
    var glassOfWater: String {
        "\(waterInTake.numberOfGlasses)잔"
    }
    
    var liter: String {
        String(format: "%.2fL", waterInTake.consumedLiters)
    }
    
    init(waterInTake: Drink) {
        self.waterInTake = waterInTake
    }
    
    func drink() {
        waterInTake.setNumberOfGlasses(1)
        waterInTake.setConsumedLitters(0.25)
    }
}
