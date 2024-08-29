//
//  DrinkViewModelTests.swift
//  MulimeeTests
//
//  Created by Kyeongmo Yang on 8/11/24.
//

import Combine
import XCTest

final class DrinkViewModelTests: XCTestCase {
    var viewModel: DrinkViewModel!
    var drink: Drink!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        drink = Drink(drinkRepository: MockDrinkRepositoryImpl(),
                          healthKitRepository: MockHealthKitRepositoryImpl())
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        drink = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testDrinkWater() async {
        // Given
        viewModel = DrinkViewModel(drink: drink)
        let expectation = XCTestExpectation(description: "Drink water")
        expectation.expectedFulfillmentCount = 1
        
        viewModel.$numberOfGlasses
            .dropFirst() // Skip the initial value
            .sink { newValue in
                if newValue == 1 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        await viewModel.drinkWater()
        
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.numberOfGlasses, 1)
        XCTAssertEqual(viewModel.consumedLiters, 0.25)
        XCTAssertEqual(viewModel.glassOfWater, "1잔")
        XCTAssertEqual(viewModel.liter, "0.25L")
    }
    
    func testDrinkWaterMaxLimit() async {
        // Given
        viewModel = DrinkViewModel(drink: drink)
        let expectation = XCTestExpectation(description: "Drink water max limit")
        expectation.expectedFulfillmentCount = 8
        
        viewModel.$numberOfGlasses
            .sink { newValue in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        for _ in 0..<8 {
            await viewModel.drinkWater()
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.numberOfGlasses, 8)
        XCTAssertTrue(viewModel.isDisabledDrinkButton)
        XCTAssertEqual(viewModel.drinkButtonBackgroundColor, .black)
        XCTAssertEqual(viewModel.drinkButtonTitle, "다마심")
    }
    
    func testReset() async {
        // Given
        viewModel = DrinkViewModel(drink: drink)
        let expectation = XCTestExpectation(description: "Reset")
        expectation.expectedFulfillmentCount = 2
        
        viewModel.$numberOfGlasses
            .dropFirst() // Skip the initial value
            .sink { newValue in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        await viewModel.drinkWater()
        await viewModel.reset()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.numberOfGlasses, 0)
        XCTAssertFalse(viewModel.isDisabledDrinkButton)
        XCTAssertEqual(viewModel.drinkButtonBackgroundColor, .teal)
        XCTAssertEqual(viewModel.drinkButtonTitle, "마시기")
    }
    
    func testConsumedLiters() async {
        // Given
        viewModel = DrinkViewModel(drink: drink)
        let expectation = XCTestExpectation(description: "Consumed Liters")
        expectation.expectedFulfillmentCount = 4
        
        viewModel.$numberOfGlasses
            .sink { newValue in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        for _ in 0..<4 {
            await viewModel.drinkWater()
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.consumedLiters, 1.0)
        XCTAssertEqual(viewModel.liter, "1.00L")
    }
}
