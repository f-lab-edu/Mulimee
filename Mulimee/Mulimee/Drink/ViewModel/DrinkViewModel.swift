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
    @Published private(set) var numberOfGlasses: Int = 0 {
        didSet { isDisabledDrinkButton = numberOfGlasses == 8 }
    }
    @Published private(set) var isDisabledDrinkButton = false
    
    var drinkButtonBackgroundColor: Color {
        isDisabledDrinkButton ? .black : .teal
    }
    var drinkButtonTitle: String {
        isDisabledDrinkButton ? "다마심" : "마시기"
    }
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
        
        bind(drink.numberOfGlasses)
    }
    
    private func bind(_ numberOfGlassesPublisher: AnyPublisher<Int, Never>) {
        numberOfGlassesPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.numberOfGlasses, on: self)
            .store(in: &self.cancellables)
    }
    
    func drinkWater() async {
        do {
            try await drink.drinkWater()
        } catch {
            // TODO: - Error 만들고 메세지 날려주기
            print(error.localizedDescription)
        }
    }
    
    func reset() async {
        do {
            try await drink.reset()
        } catch {
            // TODO: - Error 만들고 메세지 날려주기
            print(error.localizedDescription)
        }
    }
}
