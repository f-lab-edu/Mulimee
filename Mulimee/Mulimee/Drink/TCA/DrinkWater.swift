//
//  DrinkWater.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 8/12/24.
//

import Combine
import ComposableArchitecture
import Dependencies
import SwiftUI

@Reducer
struct DrinkWater {
    @ObservableState
    struct State {
        var numberOfGlasses = 0
        var prevNumberOfGlasses = 0
        var offset: CGFloat = 0
        var errorMessage = ""
        
        var glassString: String {
            "\(numberOfGlasses)잔"
        }
        var liter: String {
            String(format: "%.2fL", 0.25 * Double(numberOfGlasses))
        }
        
        var progress: CGFloat {
            0.125 * CGFloat(numberOfGlasses)
        }
        
        var isDisableDrinkButton: Bool {
            numberOfGlasses >= 8
        }
        
        var drinkButtonTtile: String {
            numberOfGlasses < 8 ? "마시기" : "다마심"
        }
        
        var drinkButtonBackgroundColor: Color {
            numberOfGlasses < 8 ? .teal : .gray
        }
    }
    
    enum Action {
        case subscribeWater
        case createDocument
        case receivedWater(Water)
        case drinkButtonTapped
        case incrementNumberOfGlasses
        case resetButtonTapped
        case resetNumberOfGlasses
        case startAnimation
        case receivedError(DrinkWaterError)
    }
    
    @Dependency(\.drinkWaterClient) var drinkWaterClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .subscribeWater:
                return .publisher {
                    self.drinkWaterClient.water(id: "1")
                        .map {
                            switch $0 {
                            case let .success(water):
                                .receivedWater(water)
                            case let .failure(error):
                                .receivedError(error)
                            }
                        }
                }
                
            case .createDocument:
                return .run { send in
                    do {
                        try await self.drinkWaterClient.createDocument("1")
                        await send(.subscribeWater)
                    } catch {
                        await send(.receivedError(.failedCreateDocument))
                    }
                }
                
            case let .receivedWater(water):
                state.numberOfGlasses = water.glasses
                return .none
                
            case .drinkButtonTapped:
                guard state.numberOfGlasses < 8 else {
                    return .none
                }
                return .concatenate(
                    .send(.incrementNumberOfGlasses),
                    .run { send in
                        do {
                            try await self.drinkWaterClient.drinkWater("1")
                        } catch {
                            await send(.receivedError(.failedIncrementDrinkWater))
                        }
                    }
                )
                
            case .incrementNumberOfGlasses:
                state.numberOfGlasses += 1
                return .none
                
            case .resetButtonTapped:
                return .concatenate(
                    .send(.resetNumberOfGlasses),
                    .run { send in
                        do {
                            try await self.drinkWaterClient.reset("1")
                        } catch {
                            await send(.receivedError(.failedResetDrinkWater))
                        }
                    }
                )
                
            case .resetNumberOfGlasses:
                state.prevNumberOfGlasses = state.numberOfGlasses
                state.numberOfGlasses = 0
                return .none
                
            case .startAnimation:
                state.offset = 360
                return .none
                
            case let .receivedError(drinkWaterError):
                switch drinkWaterError {
                case .isNotExistDocument:
                    return .send(.createDocument)
                    
                case .failedCreateDocument:
                    return .none
                    
                case .failedIncrementDrinkWater:
                    state.numberOfGlasses -= 1
                    state.errorMessage = "문제가 발생했어요!"
                    return .none
                    
                case .failedResetDrinkWater:
                    state.numberOfGlasses = state.prevNumberOfGlasses
                    state.errorMessage = "문제가 발생했어요!"
                    return .none
                }
            }
        }
    }
}

enum DrinkWaterError: Error {
    case isNotExistDocument
    case failedCreateDocument
    case failedIncrementDrinkWater
    case failedResetDrinkWater
}

