//
//  WaterInTake.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/26/24.
//

import Combine
import Foundation

struct Drink {
    private let repository: Repository
    
    private let numberOfGlassesPublisher: CurrentValueSubject<Int, Never>
    var numberOfGlasses: AnyPublisher<Int, Never> {
        numberOfGlassesPublisher.eraseToAnyPublisher()
    }
    
    init(repository: Repository) {
        self.repository = repository
        self.numberOfGlassesPublisher = .init(repository.fetchDrink())
    }
    
    func drinkWater() {
        guard numberOfGlassesPublisher.value < 8 else {
            return
        }
        let numberOfGlasses = numberOfGlassesPublisher.value + 1
        repository.setDrink(with: numberOfGlasses)
        numberOfGlassesPublisher.send(numberOfGlasses)
    }
}

extension Int {
    mutating func increment(_ value: Int = 1) {
        self += value
    }
}
 
