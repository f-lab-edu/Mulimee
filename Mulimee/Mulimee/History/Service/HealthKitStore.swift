//
//  HealthKitStore.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 8/5/24.
//

import Foundation
import HealthKit

enum HealthKitError: Error {
    case invalidObjectType
    case permissionDenied
    case healthKitInternalError
    case incompleteExecuteQuery
}

enum HealthKitAuthorizationStatus: Int {
    case notDetermined
    case sharingDenied
    case sharingAuthorized
}

final class HealthKitStore {
    private enum Constant {
        static let aGlassOfWater: Double = 250
    }
    
    private let healthStore = HKHealthStore()
    
    private var authorizationStatus: HKAuthorizationStatus {
        guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            return .notDetermined
        }
        
        return healthStore.authorizationStatus(for: waterType)
    }
    
    var isAuthorized: HealthKitAuthorizationStatus {
        switch authorizationStatus {
        case .notDetermined: .notDetermined
        case .sharingDenied: .sharingDenied
        case .sharingAuthorized: .sharingAuthorized
        @unknown default: .notDetermined
        }
    }
    
    func requestAuthorization() async throws {
        guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            throw HealthKitError.invalidObjectType
        }
        
        do {
            try await healthStore.requestAuthorization(toShare: [waterType], read: [waterType])
        } catch {
            throw HealthKitError.permissionDenied
        }
    }
    
    func readWaterIntake(from startDate: Date, to endDate: Date) async throws -> [(date: Date, amount: Double)] {
        return try await withCheckedThrowingContinuation { continuation in
            guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
                continuation.resume(throwing: HealthKitError.invalidObjectType)
                return
            }
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let query = HKStatisticsCollectionQuery(quantityType: waterType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: startDate, intervalComponents: DateComponents(day: 1))
            query.initialResultsHandler = { query, result, error in
                if error != nil {
                    continuation.resume(throwing: HealthKitError.healthKitInternalError)
                    return
                }
                
                // If this property is not set to nil, the query executes the results handler on a background queue after it has finished calculating the statistics for all matching samples currently stored in HealthKit.
                guard let result else {
                    continuation.resume(throwing: HealthKitError.incompleteExecuteQuery)
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
