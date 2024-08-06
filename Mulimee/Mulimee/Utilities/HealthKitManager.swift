//
//  HealthKitManager.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 8/5/24.
//

import Foundation
import HealthKit

enum HealthKitError: Error {
    case failedQuantityType
    case failedFetchResult
}

final class HealthKitStore {
    private enum Constant {
        static let aGlassOfWater: Double = 250
    }
    
    private let healthStore = HKHealthStore()
    
    func requestAuthorization() async throws {
        guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            throw HealthKitError.failedQuantityType
        }
        
        try await healthStore.requestAuthorization(toShare: [waterType], read: [waterType])
    }
    
    func readWaterIntake(from startDate: Date, to endDate: Date) async throws -> [(Date, Double)] {
        return try await withCheckedThrowingContinuation { continuation in
            guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
                continuation.resume(throwing: HealthKitError.failedQuantityType)
                return
            }
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let query = HKStatisticsCollectionQuery(quantityType: waterType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: startDate, intervalComponents: DateComponents(day: 1))
            query.initialResultsHandler = { query, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let result else {
                    continuation.resume(throwing: HealthKitError.failedFetchResult)
                    return
                }
                
                var waterIntakeResults: [(Date, Double)] = []
                
                result.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    let date = statistics.startDate
                    let waterInTake = statistics.sumQuantity()?.doubleValue(for: .literUnit(with: .milli)) ?? 0
                    waterIntakeResults.append((date, waterInTake))
                }
                continuation.resume(returning: waterIntakeResults)
            }
            
            healthStore.execute(query)
        }
    }
}
