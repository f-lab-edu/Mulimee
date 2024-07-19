//
//  MulimeeIntent.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 7/20/24.
//

import AppIntents
import Foundation

struct MulimeeIntent: AppIntent {
    static var title: LocalizedStringResource = "Drink Water"
    static var description = IntentDescription("Glasses of Today counter")
    
    private let repository: Repository = RepositoryImpl()
    
    func perform() async throws -> some IntentResult {
        var numberOfGlasses = repository.fetchDrink()
        numberOfGlasses.increment()
        repository.setDrink(with: numberOfGlasses)
        return .result()
    }
}
