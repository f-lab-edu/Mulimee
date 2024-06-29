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
    private var waterInTake: Drink
    private(set) var waterDropViewModel: WaterDropViewModel
    
    var glassOfWater: String {
        "\(waterInTake.numberOfGlasses)잔"
    }
    
    var liter: String {
        String(format: "%.2fL", waterInTake.consumedLiters)
    }
    
    init(waterInTake: Drink) {
        self.waterInTake = waterInTake
        self.waterDropViewModel = .init(waterWaveProgress: waterInTake.waterWaveProgress)
    }
    
    func drink() {
        waterInTake.setNumberOfGlasses(1)
        waterInTake.setConsumedLitters(0.25)
    }
}
