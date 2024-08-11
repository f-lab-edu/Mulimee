//
//  WaterInTake.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/26/24.
//

import Combine
import Foundation

final class Drink {
    private let drinkRepository: DrinkRepository
    private let healthKitRepository: HealthKitRepository
    
    private let numberOfGlassesSubject: CurrentValueSubject<Int, Never>
    var numberOfGlasses: AnyPublisher<Int, Never> {
        numberOfGlassesSubject.eraseToAnyPublisher()
    }
    private let errorSubject = PassthroughSubject<Void, Error>()
    var drinkError: AnyPublisher<Void, Error> {
        errorSubject.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    var glasses: Int {
        numberOfGlassesSubject.value
    }
    
    init(drinkRepository: DrinkRepository,
         healthKitRepository: HealthKitRepository) {
        self.drinkRepository = drinkRepository
        self.healthKitRepository = healthKitRepository
        self.numberOfGlassesSubject = .init(0)
        
        Task {
            guard await drinkRepository.isExistDocument else {
                do {
                    try await drinkRepository.createDocument()
                    await bind()
                } catch {
                    errorSubject.send(completion: .failure(error))
                }
                return
            }
            
            await self.bind()
        }
    }
    
    func drinkWater() async throws {
        guard numberOfGlassesSubject.value < 8 else {
            return
        }
        
        try await repository.setDrink()
    }
    
    func reset() async throws {
        try await drinkRepository.reset()
        try await healthKitRepository.resetWaterInTakeInToday()
    }
    
    private func bind() async {
        drinkRepository.glassPublisher
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("finish")
                }
            } receiveValue: { [weak self] water in
                self?.numberOfGlassesSubject.send(water.glasses)
            }
            .store(in: &cancellables)
    }
    
    func restore() {
        numberOfGlassesSubject.send(glasses - 1)
    }
}
