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
    var mockService: DrinkRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockDrinkService()
        drink = Drink(repository: mockService)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        drink = nil
        mockService = nil
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
        for _ in 0..<8 {
            try await drink.drinkWater()
        }
        
        // When
        try await drink.drinkWater()
        
        // Then
        XCTAssertEqual(drink.glasses, 8)
    }
    
    func testReset() async throws {
        // Given
        try await drink.drinkWater()
        try await drink.drinkWater()
        
        // When
        try await drink.reset()
        
        // Then
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

final class MockDrinkService: DrinkRepository {
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
