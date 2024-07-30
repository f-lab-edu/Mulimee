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
    
    var glasses: Int {
        numberOfGlassesPublisher.value
    }
    
    init(repository: DrinkRepository) {
        self.repository = repository
        self.numberOfGlassesPublisher = .init(0)
        
        Task {
            await bind()
        }
    }
    
    func drinkWater() async throws {
        guard numberOfGlassesPublisher.value < 8 else {
            return
        }
        numberOfGlassesPublisher.send(glasses + 1)
        try await repository.setDrink()
    }
    
    func reset() async throws {
        try await repository.reset()
    }
    
    private func bind() async {
        guard await repository.isExistDocument() else {
            repository.createDocument()
                .sink { completion in
                    print(completion)
                } receiveValue: { _ in
                    Task { [weak self] in
                        await self?.bind()
                    }
                }
                .store(in: &cancellables)
            return
        }
        
        repository.glassPublisher
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("finish")
                }
            } receiveValue: { [weak self] water in
                self?.numberOfGlassesPublisher.send(water.glasses)
            }
            .store(in: &cancellables)
    }
    
    func restore() {
        numberOfGlassesPublisher.send(glasses - 1)
    }
}

