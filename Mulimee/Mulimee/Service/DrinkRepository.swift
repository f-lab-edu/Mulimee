//
//  Repository.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 7/6/24.
//

import Combine
import Foundation
import WidgetKit

protocol DrinkRepository: Sendable {
    var glassPublisher: AnyPublisher<Water, Error> { get }
    
    func setDrink() async throws
    func reset() async throws
}

final class DrinkRepositoryService: DrinkRepository {
    private let mulimeeFirestore = MulimeeFirestore()
    
    var glassPublisher: AnyPublisher<Water, any Error> {
        mulimeeFirestore.documentPublisher(userId: "1")
    }
    
    func setDrink() async throws {
        try await mulimeeFirestore.drink(userId: "1")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func reset() async throws {
        try await mulimeeFirestore.reset(userId: "1")
        WidgetCenter.shared.reloadAllTimelines()
    }
}
