//
//  HealthKitService.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 8/11/24.
//

import Foundation

final class HealthKitRepositoryImpl: HealthKitRepository {
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
