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
