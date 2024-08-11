//
//  DrinkTests.swift
//  MulimeeTests
//
//  Created by Kyeongmo Yang on 8/11/24.
//

import Combine
import XCTest

final class DrinkTests: XCTestCase {
    var drink: Drink!
    var mockDrinkRepository: DrinkRepository!
    var mockHeatlKitRepository: HealthKitRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockDrinkRepository = MockDrinkRepositoryImpl()
        mockHeatlKitRepository = MockHealthKitRepositoryImpl()
        drink = Drink(drinkRepository: mockDrinkRepository, healthKitRepository: mockHeatlKitRepository)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        drink = nil
        mockDrinkRepository = nil
        mockHeatlKitRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testDrinkWater() async throws {
        // Given
        let expectation = XCTestExpectation(description: "Drink water")
        
        // When
        try await drink.drinkWater()
        
        // Then
        drink.numberOfGlasses.sink { glasses in
            XCTAssertEqual(glasses, 1)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testDrinkWaterMaxLimit() async throws {
        // Given
        let expectation = XCTestExpectation(description: "Drink water max limit")
        expectation.expectedFulfillmentCount = 8
        
        drink.numberOfGlasses.sink { glasses in
            expectation.fulfill()
        }.store(in: &cancellables)
        
        // When
        for _ in 0..<8 {
            try await drink.drinkWater()
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(drink.glasses, 8)
    }
    
    func testReset() async throws {
        // Given
        let expectation = XCTestExpectation(description: "Drink water max limit")
        expectation.expectedFulfillmentCount = 3
        
        drink.numberOfGlasses.sink { glasses in
            expectation.fulfill()
        }.store(in: &cancellables)
        
        // When
        try await drink.drinkWater()
        try await drink.drinkWater()
        try await drink.reset()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(drink.glasses, 0)
    }
    
    func testContinuousUpdates() async throws {
        // Given
        let expectation = XCTestExpectation(description: "Continuous updates")
        expectation.expectedFulfillmentCount = 3
        
        var receivedValues: [Int] = []
        
        drink.numberOfGlasses
            .removeDuplicates()
            .sink { glasses in
            receivedValues.append(glasses)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        // When
        try await drink.drinkWater()
        try await drink.drinkWater()
        try await drink.drinkWater()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedValues, [0, 1, 2, 3])
    }
}

private final class MockDrinkRepositoryImpl: DrinkRepository {
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

private final class MockHealthKitRepositoryImpl: HealthKitRepository {
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
