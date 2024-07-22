//
//  WaterInTake.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/26/24.
//

import Combine
import Foundation

final class Drink: ObservableObject {
    private let repository: Repository
    
    @Published private(set) var numberOfGlasses: Int {
        didSet { numberOfGlassesPublisher.send(numberOfGlasses) }
    }
    let numberOfGlassesPublisher: CurrentValueSubject<Int, Never>
    
    init(numberOfGlasses: Int, repository: Repository) {
        self.numberOfGlasses = numberOfGlasses
        self.repository = repository
        self.numberOfGlassesPublisher = .init(numberOfGlasses)
    }
    
    func drinkWater() {
        guard numberOfGlasses < 8 else {
            return
        }
        numberOfGlasses.increment()
        repository.setDrink(with: numberOfGlasses)
    }
}

extension Int {
    mutating func increment(_ value: Int = 1) {
        self += value
    }
}
 
