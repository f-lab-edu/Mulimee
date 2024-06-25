//
//  DrinkViewModel.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/26/24.
//

import Foundation
import Observation

@Observable
class DrinkViewModel {
    private var waterInTake: WaterInTake
    
    var glassOfWater: String {
        "\(waterInTake.numberOfGlasses)잔"
    }
    
    var liter: String {
        String(format: "%.2fL", waterInTake.consumedLiters)
    }
    
    init(waterInTake: WaterInTake) {
        self.waterInTake = waterInTake
    }
    
    func drink() {
        waterInTake.setNumberOfGlasses(1)
        waterInTake.setConsumedLitters(0.25)
    }
}
