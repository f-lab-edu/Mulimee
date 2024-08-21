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
        case resetButtonTapped
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
                    try await self.drinkWaterClient.createDocument("1")
                    await send(.subscribeWater)
                }
                
            case let .receivedWater(water):
                state.numberOfGlasses = water.glasses
                return .none
                
            case .drinkButtonTapped:
                guard state.numberOfGlasses < 8 else {
                    return .none
                }
                return .run { send in
                    do {
                        try await self.drinkWaterClient.drinkWater("1")
                    } catch {
                        await send(.receivedError(.failedIncrementDrinkWater))
                    }
                }
                
            case .resetButtonTapped:
                return .run { send in
                    do {
                        try await self.drinkWaterClient.reset("1")
                    } catch {
                        await send(.receivedError(.failedResetDrinkWater))
                    }
                }
                
            case .startAnimation:
                state.offset = 360
                return .none
                
            case let .receivedError(drinkWaterError):
                switch drinkWaterError {
                case .failedFetchNumberOfGlasses:
                    state.errorMessage = "문제가 발생했어요!"
                    return .none
                    
                case .isNotExistDocument:
                    return .send(.createDocument)
                    
                case .failedIncrementDrinkWater:
                    state.errorMessage = "문제가 발생했어요!"
                    return .none
                    
                case .failedResetDrinkWater:
                    state.errorMessage = "문제가 발생했어요!"
                    return .none
                }
            }
        }
    }
}

struct DrinkWaterView: View {
    @Bindable var store: StoreOf<DrinkWater>
    
    var body: some View {
        ZStack {
            Color(.fogMist)
                .ignoresSafeArea()
            
            VStack {
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    ZStack {
                        Image(systemName: "drop.fill")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .scaleEffect(x: 1.1, y: 1.1)
                            .offset(y: -1)
                        
                        WaterWaveView(
                            progress: store.progress,
                            waveHeight: 0.1,
                            offset: store.offset
                        )
                        .fill(.teal)
                        .overlay {
                            ZStack {
                                // water drop
                                GlareCircleView(sizeConstant: 15,
                                              offset: .init(x: -20, y: 0))
                                
                                GlareCircleView(sizeConstant: 15,
                                              offset: .init(x: 40, y: 30))
                                
                                GlareCircleView(sizeConstant: 25,
                                              offset: .init(x: -30, y: 80))
                                
                                GlareCircleView(sizeConstant: 25,
                                              offset: .init(x: 50, y: 70))
                                
                                GlareCircleView(sizeConstant: 10,
                                              offset: .init(x: 40, y: 100))
                            }
                        }
                        .mask {
                            Image(systemName: "drop.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .frame(width: size.width, height: size.height, alignment: .center)
                }
                .frame(height: 450)
                
                HStack(alignment: .firstTextBaseline) {
                    Text(store.glassString)
                        .font(.title)
                    Text(store.liter)
                        .font(.callout)
                }
                .padding()
                
                HStack {
                    Button {
                        store.send(.drinkButtonTapped)
                    } label: {
                        Text("마시기")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .background(store.drinkButtonBackgroundColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(store.isDisableDrinkButton)
                    
                    
                    Button {
                        store.send(.resetButtonTapped)
                    } label: {
                        Text("초기화")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .onAppear {
            store.send(.subscribeWater)
            
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) { () -> Void in
                store.send(.startAnimation)
            }
        }
    }
}

enum DrinkWaterError: Error {
    case isNotExistDocument
    case failedFetchNumberOfGlasses
    case failedIncrementDrinkWater
    case failedResetDrinkWater
}

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

extension DependencyValues {
    var drinkWaterClient: DrinkWaterClient {
        get { self[DrinkWaterClient.self] }
        set { self[DrinkWaterClient.self] = newValue }
    }
}

#Preview {
    DrinkWaterView(store: Store(initialState: DrinkWater.State()) {
        DrinkWater()
    })
}
