//
//  WaterInTake.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/26/24.
//

import Foundation

struct Drink {
    private(set) var numberOfGlasses: Int
    
    var consumedLiters: Double {
        0.25 * Double(numberOfGlasses)
    }
    var waterWaveProgress: CGFloat {
        CGFloat(numberOfGlasses) / 8
    }
    
    init(numberOfGlasses: Int) {
        self.numberOfGlasses = numberOfGlasses
    }
    
    mutating func drinkWtaer() {
        guard numberOfGlasses < 8 else {
            return
        }
        numberOfGlasses.increment()
    }
}

extension Int {
    mutating func increment(_ value: Int = 1) {
        self += value
    }
}
