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
