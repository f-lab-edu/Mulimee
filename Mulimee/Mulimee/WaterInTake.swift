//
//  WaterInTake.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/26/24.
//

import Foundation

protocol DrinkProtocol {
    var numberOfGlasses: Int { get }
    var consumedLiters: Double { get }
    
    mutating func setNumberOfGlasses(_ value: Int)
    mutating func setConsumedLitters(_ value: Double)
}

struct Drink {
    private(set) var numberOfGlasses: Int
    private(set) var consumedLiters: Double
    
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
