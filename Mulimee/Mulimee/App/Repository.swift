//
//  Repository.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 7/6/24.
//

import Foundation
import WidgetKit

protocol Repository: Sendable {
    func fetchDrink() -> Int
    func setDrink(with value: Int)
    func reset()
}

final class RepositoryImpl: Repository {
    func fetchDrink() -> Int {
        UserDefaults.appGroup.glassesOfToday
    }
    
    func setDrink(with value: Int) {
        UserDefaults.appGroup.setValue(value, forKey: .glassesOfToday)
        WidgetCenter.shared.reloadAllTimelines()
    
    func reset() {
        UserDefaults.appGroup.glassesOfToday = .zero
    }
}
