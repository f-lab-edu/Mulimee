//
//  RepositoryImpl.swift
//  MulimeeTests
//
//  Created by Kyeongmo Yang on 8/11/24.
//

import Combine
import Foundation

final class MockDrinkRepositoryImpl: DrinkRepository {
    private let waterSubject: CurrentValueSubject<Water, any Error> = CurrentValueSubject(Water(glasses: 0))
    
    var glassPublisher: AnyPublisher<Water, any Error> {
        waterSubject
            .eraseToAnyPublisher()
    }
    
    var isExistDocument: Bool {
        true
    }
    
    func createDocument() async throws {}
    
    func fetchDrink() async throws -> Water {
        waterSubject.value
    }
    
    func setDrink() async throws {
        let newValue = Water(glasses: waterSubject.value.glasses + 1)
        waterSubject.send(newValue)
    }
    
    func reset() async throws {
        waterSubject.send(Water(glasses: .zero))
    }
}

final class MockHealthKitRepositoryImpl: HealthKitRepository {
    func requestAuthorization() async throws {}
    
    var healthKitAuthorizationStatus: HealthKitAuthorizationStatus {
        .sharingAuthorized
    }
    
    func fetch(from startDate: Date, to endDate: Date) async throws -> [History] {
        createAugust2024Dates().map { History(date: $0, mililiter: 250) }
    }
    
    private func createAugust2024Dates() -> [Date] {
        let calendar = Calendar.current
        
        // 2024년 8월 1일의 시작 날짜를 만듭니다.
        let startDate = calendar.date(from: DateComponents(year: 2024, month: 8, day: 1))!
        let endDate = calendar.date(from: DateComponents(year: 2024, month: 8, day: 31))!
        let numberOfDays = calendar.dateComponents([.day], from: startDate, to: endDate).day!
        
        return (0...numberOfDays).compactMap { calendar.date(byAdding: .day, value: $0, to: startDate) }
    }
    
    func drinkAGlassOfWater() async throws {}
    
    func resetWaterInTakeInToday() async throws {}
}
