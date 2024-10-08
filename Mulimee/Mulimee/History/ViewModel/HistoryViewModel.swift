//
//  HistoryViewModel.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 8/4/24.
//

import SwiftUI

final class HistoryViewModel: ObservableObject {
    private let repository: HealthKitRepository = HealthKitRepositoryImpl()
    
    private var year: Int
    private var month: Int
    var dateString: String
    @Published private(set) var histories: [History] = []
    @Published var showAuthorizationAlert = false
    @Published var showErrorAlert = false
    var errorMessage: String = ""
    
    private let calendar = Calendar.current
    
    @Published var healthKitAuthorizationStatus: HealthKitAuthorizationStatus = .notDetermined {
        didSet {
            if healthKitAuthorizationStatus == .sharingDenied {
                Task { @MainActor in
                    showAuthorizationAlert = true
                }
            }
        }
    }
    
    init() {
        let now = Date.now
        year = calendar.component(.year, from: now)
        month = calendar.component(.month, from: now)
        dateString = "\(year)년 \(month)월"
        healthKitAuthorizationStatus = repository.healthKitAuthorizationStatus
    }
    
    private func getStartAndEndDate() -> (startDate: Date?, endDate: Date?) {
        let startDateComponents = DateComponents(year: year, month: month, day: 1)
        
        guard let startDate = calendar.date(from: startDateComponents),
              let range = calendar.range(of: .day, in: .month, for: startDate) else {
            return (nil, nil)
        }
        let endDateComponents = DateComponents(year: year, month: month, day: range.count)
        let endDate = calendar.date(from: endDateComponents)
        
        return (startDate, endDate)
    }
    
    @MainActor
    func requestAuthorization() async {
        do {
            try await repository.requestAuthorization()
            healthKitAuthorizationStatus = repository.healthKitAuthorizationStatus
        } catch {
            handleError(error)
        }
    }
    
    @MainActor
    func fetchHistores() async {
        histories.removeAll()
        
        let (start, end) = getStartAndEndDate()
        guard let start, let end else {
            return
        }
        do {
            histories = try await repository.fetch(from: start, to: end)
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        guard let healthKitError = error as? HealthKitError else {
            errorMessage = "문제가 발생했습니다."
            return
        }
        switch healthKitError {
        case .invalidObjectType: 
            errorMessage = "잘못된 타입입니다."
        case .permissionDenied:
            errorMessage = "권한이 없습니다."
        case .healthKitInternalError:
            errorMessage = "HealthKit 프레임워크 내부 에러입니다."
        case .incompleteExecuteQuery:
            errorMessage = "쿼리가 계산을 끝내지 못했습니다."
        }
    }
}
