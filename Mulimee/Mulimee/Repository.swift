//
//  Repository.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 7/6/24.
//

import Foundation

protocol Repository {
    func fetchDrink() -> Int
    func setDrink(with value: Int)
    func reset()
}

final class RepositoryImpl: Repository {
    func fetchDrink() -> Int {
        UserDefaults.appGroup.glassesOfToday
    }
    
    func setDrink(with value: Int) {
        UserDefaults.appGroup.glassesOfToday = value
    }
    
    func reset() {
        UserDefaults.appGroup.glassesOfToday = .zero
    }
}
