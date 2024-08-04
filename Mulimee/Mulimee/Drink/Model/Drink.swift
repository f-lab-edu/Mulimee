//
//  WaterInTake.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/26/24.
//

import Combine
import Foundation

final class Drink {
    private let repository: DrinkRepository
    
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
    
    init(repository: DrinkRepository) {
        self.repository = repository
        self.numberOfGlassesSubject = .init(0)
        
        Task {
            guard await repository.isExistDocument else {
                do {
                    try await repository.createDocument()
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
        numberOfGlassesSubject.send(glasses + 1)
        try await repository.setDrink()
    }
    
    func reset() async throws {
        try await repository.reset()
    }
    
    private func bind() async {
        repository.glassPublisher
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

