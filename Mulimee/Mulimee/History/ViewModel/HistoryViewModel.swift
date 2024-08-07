//
//  HistoryViewModel.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 8/4/24.
//

import SwiftUI

final class HistoryViewModel: ObservableObject {
    private let repository: HealthKitRepository = HealthKitService()
    
    private var year: Int
    private var month: Int
    var dateString: String
    @Published private(set) var histories: [History] = []
    @Published var showAuthorizationAlert = false
    @Published var showErrorAlert = false
    var errorMessage: String = ""
    
    private let calendar = Calendar.current
    
    var isHealthKitAuthorized: HealthKitAuthorizationStatus {
        let isAuthorized = repository.isAuthorized
        if isAuthorized == .sharingDenied {
            Task { @MainActor in
                showAuthorizationAlert = true
            }
        }
        return isAuthorized
    }
    
    init() {
        let now = Date.now
        year = calendar.component(.year, from: now)
        month = calendar.component(.month, from: now)
        dateString = "\(year)년 \(month)월"
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
        let message: String = switch healthKitError {
        case .invalidObjectType: "잘못된 타입입니다."
        case .permissionDenied: "권한이 없습니다."
        case .healthKitInternalError: "HealthKit 프레임워크 내부 에러입니다."
        case .incompleteExecuteQuery: "쿼리가 계산을 끝내지 못했습니다."
        }
        errorMessage = message
    }
}
