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
    private var month: Int {
        didSet { dateString = "\(year)년 \(month)월" }
    }
    @Published var dateString: String = ""
    @Published private(set) var histories: [History] = []
    
    private let calendar = Calendar.current
    
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
    
    func requestAuthorization() async {
        do {
            try await repository.requestAuthorization()
        } catch {
            print(error.localizedDescription)
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
            print(error.localizedDescription)
        }
    }
}
