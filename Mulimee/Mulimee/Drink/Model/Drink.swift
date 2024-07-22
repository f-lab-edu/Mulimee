//
//  WaterInTake.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/26/24.
//

import Combine
import Foundation

final class Drink {
    private let repository: Repository
    
    private let numberOfGlassesPublisher: CurrentValueSubject<Int, Never>
    var numberOfGlasses: AnyPublisher<Int, Never> {
        numberOfGlassesPublisher.eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: Repository) {
        self.repository = repository
        self.numberOfGlassesPublisher = .init(repository.fetchDrink())
        
        UserDefaults.appGroup.publisher(for: \.glassesOfToday)
            .sink { [unowned self] numberOfGlass in
                numberOfGlassesPublisher.send(numberOfGlass)
            }
            .store(in: &cancellables)
    }
    
    func drinkWater() {
        guard numberOfGlassesPublisher.value < 8 else {
            return
        }
        let numberOfGlasses = numberOfGlassesPublisher.value + 1
        repository.setDrink(with: numberOfGlasses)
        numberOfGlassesPublisher.send(numberOfGlasses)
    }
    
    func reset() {
        numberOfGlassesPublisher.send(.zero)
        repository.reset()
	}
}
