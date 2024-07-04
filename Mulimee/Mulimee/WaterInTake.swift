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
        numberOfGlasses += value
    }
    
    mutating func setConsumedLitters(_ value: Double) {
        consumedLiters += value
    }
}
