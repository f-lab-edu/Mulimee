//
//  MulimeeIntent.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 7/20/24.
//

import AppIntents

struct MulimeeIntent: AppIntent {
    static var title: LocalizedStringResource = "Drink Water"
    static var description = IntentDescription("Glasses of Today counter")
    
    func perform() async throws -> some IntentResult {
        try await DrinkRepositoryService().setDrink()
        return .result()
    }
}
