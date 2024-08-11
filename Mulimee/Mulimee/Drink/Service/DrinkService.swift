//
//  DrinkService.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 8/11/24.
//

import Combine
import Foundation
import WidgetKit

final class DrinkService: DrinkRepository {
    private let mulimeeFirestore = MulimeeFirestore()
    
    var glassPublisher: AnyPublisher<Water, any Error> {
        mulimeeFirestore.documentPublisher(userId: "1")
    }
    
    var isExistDocument: Bool {
        get async {
            await mulimeeFirestore.isExistDocument(userId: "1")
        }
    }
    
    func createDocument() async throws {
        try await mulimeeFirestore.createDocument(userId: "1")
    }
    
    func fetchDrink() async throws -> Water {
        try await mulimeeFirestore.fetch(userId: "1")
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
