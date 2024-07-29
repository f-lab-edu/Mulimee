//
//  WaterInTake.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/26/24.
//

import Combine
import Foundation

final class Drink {
    private let numberOfGlassesPublisher: CurrentValueSubject<Int, Never>
    var numberOfGlasses: AnyPublisher<Int, Never> {
        numberOfGlassesPublisher.eraseToAnyPublisher()
    }
    private let repository: DrinkRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: DrinkRepository) {
        self.repository = repository
        self.numberOfGlassesPublisher = .init(0)
        
        self.bind()
    }
    
    func drinkWater() async throws {
        guard numberOfGlassesPublisher.value < 8 else {
            return
        }
        try await repository.setDrink()
    }
    
    func reset() async throws {
        try await repository.reset()
    }
    
    private func bind() {
        repository.glassPublisher
            .sink { completion in
                switch completion {
                case .failure(let error):
                    fatalError(error.localizedDescription)
                case .finished:
                    print("finish")
                }
            } receiveValue: { [weak self] water in
                self?.numberOfGlassesPublisher.send(water.glasses)
            }
            .store(in: &cancellables)
    }
}

