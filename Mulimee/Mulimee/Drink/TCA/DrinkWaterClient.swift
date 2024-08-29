//
//  DrinkWaterClient.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 8/30/24.
//

import Combine
import ComposableArchitecture

@DependencyClient
struct DrinkWaterClient {
    var water: @Sendable (_ id: String) -> AnyPublisher<Result<Water, DrinkWaterError>, Never> = { _ in
        CurrentValueSubject(.success(.init(glasses: 0)))
            .eraseToAnyPublisher()
    }
    var createDocument: @Sendable (_ id: String) async throws -> Void
    var drinkWater: @Sendable (_ id: String) async throws -> Void
    var reset: @Sendable (_ id: String) async throws -> Void
}

extension DependencyValues {
    var drinkWaterClient: DrinkWaterClient {
        get { self[DrinkWaterClient.self] }
        set { self[DrinkWaterClient.self] = newValue }
    }
}

extension DrinkWaterClient: TestDependencyKey {
    static var previewValue = Self(
        water: { _ in
            CurrentValueSubject(.success(.init(glasses: 0)))
                .eraseToAnyPublisher()
        },
        createDocument: { _ in
            return
        },
        drinkWater: { _ in
            return
        }, reset: { _ in
            return
        }
    )
}

extension DrinkWaterClient: DependencyKey {
    static let liveValue = Self(
        water: { id in
            MulimeeFirestore().documentPublisher(userId: id)
                .map { .success($0) }
                .catch { _ in
                    Just(.failure(DrinkWaterError.isNotExistDocument))
                }
                .eraseToAnyPublisher()
        },
        createDocument: { id in
            try await MulimeeFirestore().createDocument(userId: id)
        },
        drinkWater: { id in
            try await MulimeeFirestore().drink(userId: id)
        }, reset: { id in
            try await MulimeeFirestore().reset(userId: id)
        }
    )
}
