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
}

final class RepositoryImpl: Repository {
    func fetchDrink() -> Int {
        let numberOfGlassesOfToday = UserDefaults.appGroup.integer(forKey: .glassesOfToday)
        return numberOfGlassesOfToday
    }
    
    func setDrink(with value: Int) {
        UserDefaults.appGroup.setValue(value, forKey: .glassesOfToday)
    }
}
