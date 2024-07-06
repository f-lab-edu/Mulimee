//
//  Repository.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 7/6/24.
//

import Foundation

protocol Repository {
    func fetchDrink() -> Drink
    func setDrink(with value: Int)
}

final class RepositoryImpl: Repository {
    func fetchDrink() -> Drink {
        let numberOfGlassesOfToday = UserDefaults.appGroup.integer(forKey: .glassesOfToday)
        return Drink(numberOfGlasses: numberOfGlassesOfToday)
    }
    
    func setDrink(with value: Int) {
        UserDefaults.appGroup.setValue(value, forKey: .glassesOfToday)
    }
}
