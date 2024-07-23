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
    private var numberOfGlasses: Int
    
    init() {
        self.numberOfGlasses = repository.fetchDrink()
    }
    
    func perform() async throws -> some IntentResult {
        repository.setDrink(with: numberOfGlasses + 1)
        return .result()
    }
}
