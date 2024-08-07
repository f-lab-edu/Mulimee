//
//  HealthKitRepository.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 8/5/24.
//

import Foundation

protocol HealthKitRepository {
    var isAuthorized: HealthKitAuthorizationStatus { get }
    
    func requestAuthorization() async throws
    func fetch(from startDate: Date, to endDate: Date) async throws -> [History]
}

final class HealthKitService: HealthKitRepository {
    private let healthKitStore = HealthKitStore()
    
    var isAuthorized: HealthKitAuthorizationStatus {
        healthKitStore.isAuthorized
    }
    
    func requestAuthorization() async throws {
        try await healthKitStore.requestAuthorization()
    }
    
    func fetch(from startDate: Date, to endDate: Date) async throws -> [History] {
        try await healthKitStore.readWaterIntake(from: startDate, to: endDate).map { History(date: $0.0, mililiter: $0.1) }
    }
}
