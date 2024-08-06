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
    @Published var showAlert: Bool = false
    
    var drinkButtonBackgroundColor: Color {
        isDisabledDrinkButton ? .black : .teal
    }
    var drinkButtonTitle: String {
        isDisabledDrinkButton ? "다마심" : "마시기"
    }
    private let healthKitRepository: HealthKitRepository = HealthKitService()
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
        
        bind()
    }
    
    private func bind() {
        drink.numberOfGlasses
            .receive(on: DispatchQueue.main)
            .assign(to: \.numberOfGlasses, on: self)
            .store(in: &self.cancellables)
        
        drink.drinkError
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                switch completion {
                case .finished: return
                case .failure: showAlert.toggle()
                }
            } receiveValue: {}
            .store(in: &cancellables)
    }
    
    func drinkWater() async {
        do {
            try await drink.drinkWater()
            try await healthKitRepository.setDrink()
        } catch {
            drink.restore()
            showAlert.toggle()
        }
    }
    
    func reset() async {
        do {
            try await drink.reset()
            try await healthKitRepository.reset()
        } catch {
            print(error.localizedDescription)
            showAlert.toggle()
        }
    }
}
