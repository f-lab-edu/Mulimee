//
//  HealthKitRepository.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 8/5/24.
//

import Foundation

protocol HealthKitRepository {
    var healthKitAuthorizationStatus: HealthKitAuthorizationStatus { get }
    
    func requestAuthorization() async throws
    func fetch(from startDate: Date, to endDate: Date) async throws -> [History]
    func drinkAGlassOfWater() async throws
    func resetWaterInTakeInToday() async throws
}

final class HealthKitService: HealthKitRepository {
    private let healthKitStore = HealthKitStore()
    
    var healthKitAuthorizationStatus: HealthKitAuthorizationStatus {
        healthKitStore.healthKitAuthorizationStatus
    }
    
    func requestAuthorization() async throws {
        try await healthKitStore.requestAuthorization()
    }
    
    func fetch(from startDate: Date, to endDate: Date) async throws -> [History] {
        try await healthKitStore.readWaterIntake(from: startDate, to: endDate).map { History(date: $0.date, mililiter: $0.amount) }
    }
    
    func drinkAGlassOfWater() async throws {
        try await healthKitStore.setAGlassOfWater()
    }
    
    func resetWaterInTakeInToday() async throws {
        try await healthKitStore.resetWaterInTakeInToday()
    }
}
