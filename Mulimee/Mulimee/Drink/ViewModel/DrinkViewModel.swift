//
//  DrinkViewModel.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/26/24.
//

import Combine
import Foundation
import SwiftUI

final class DrinkViewModel: ObservableObject {
    let drink: Drink
    @Published private(set) var numberOfGlasses: Int = 0
    private var cancellables = Set<AnyCancellable>()
    
    var consumedLiters: Double {
        0.25 * Double(numberOfGlasses)
    }
    
    var glassOfWater: String {
        "\(numberOfGlasses)잔"
    }
    
    var liter: String {
        String(format: "%.2fL", consumedLiters)
    }
    
    init(drink: Drink) {
        self.drink = drink
        
        bind(drink.numberOfGlassesPublisher)
    }
    
    private func bind(_ numberOfGlassesPublisher: CurrentValueSubject<Int, Never>) {
        numberOfGlassesPublisher
            .assign(to: \.numberOfGlasses, on: self)
            .store(in: &self.cancellables)
    }
    
    func drinkWater() {
        drink.drinkWater()
    }
}
