//
//  WaterInTake.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/26/24.
//

import Foundation

struct WaterInTake {
    private(set) var numberOfGlasses: Int = 0
    private(set) var consumedLiters: Double = 0
    var waterWaveProgress: CGFloat {
        CGFloat(numberOfGlasses) / 8
    }
    
    mutating func setNumberOfGlasses(_ value: Int) {
        guard numberOfGlasses < 8 else {
            return
        }
        numberOfGlasses += value
    }
    
    mutating func setConsumedLitters(_ value: Double) {
        guard consumedLiters < 2.0 else {
            return
        }
        consumedLiters += value
    }
}
