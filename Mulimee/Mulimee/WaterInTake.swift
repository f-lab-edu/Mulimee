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
    
    mutating func setNumberOfGlasses(_ value: Int) {
        numberOfGlasses += value
    }
    
    mutating func setConsumedLitters(_ value: Double) {
        consumedLiters += value
    }
}
