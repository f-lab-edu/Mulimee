//
//  DrinkWater.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 8/12/24.
//

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
        case onAppear
        case documentCreated
        case fetchNumberOfGlasses(Int)
        case drinkButtonTapped
        case incrementDrinkWater
        case resetButtonTapped
        case resetDrinkWater
        case startAnimation
        case receivedError(DrinkWaterError)
    }
    
    @Dependency(\.drinkWaterClient) var drinkWaterClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    do {
                        guard try await self.drinkWaterClient.isExistDocument() else {
                            return await send(.documentCreated)
                        }
                        
                        let numberOfGlasses = try await self.drinkWaterClient.fetchNumberOfGlasses()
                        await send(.fetchNumberOfGlasses(numberOfGlasses))
                    } catch {
                        await send(.receivedError(.failedFetchNumberOfGlasses))
                    }
                }
                
            case .documentCreated:
                return .run { send in
                    do {
                        try await self.drinkWaterClient.createDocument()
                        await send(.onAppear)
                    } catch {
                        await send(.receivedError(.failedCreatedDocument))
                    }
                }
                
            case let .fetchNumberOfGlasses(numberOfGlasses):
                state.numberOfGlasses = numberOfGlasses
                return .none
                
            case .drinkButtonTapped:
                guard state.numberOfGlasses < 8 else {
                    return .none
                }
                return .run { send in
                    do {
                        try await self.drinkWaterClient.drinkWater()
                        await send(.incrementDrinkWater)
                    } catch {
                        await send(.receivedError(.failedIncrementDrinkWater))
                    }
                }
                
            case .incrementDrinkWater:
                state.numberOfGlasses += 1
                return .none
                
            case .resetButtonTapped:
                return .run { send in
                    do {
                        try await self.drinkWaterClient.reset()
                        await send(.resetDrinkWater)
                    } catch {
                        await send(.receivedError(.failedResetDrinkWater))
                    }
                }
                
            case .resetDrinkWater:
                state.numberOfGlasses = 0
                return .none
                
            case .startAnimation:
                state.offset = 360
                return .none
                
            case let .receivedError(drinkWaterError):
                switch drinkWaterError {
                case .failedFetchNumberOfGlasses:
                    state.errorMessage = "문제가 발생했어요!"
                    
                case .failedCreatedDocument:
                    state.errorMessage = "문제가 발생했어요!"
                    
                case .failedIncrementDrinkWater:
                    state.errorMessage = "문제가 발생했어요!"
                    
                case .failedResetDrinkWater:
                    state.errorMessage = "문제가 발생했어요!"
                }
                
                return .none
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
            store.send(.onAppear)
            
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) { () -> Void in
                store.send(.startAnimation)
            }
        }
    }
}

enum DrinkWaterError: Error {
    case failedCreatedDocument
    case failedFetchNumberOfGlasses
    case failedIncrementDrinkWater
    case failedResetDrinkWater
}

@DependencyClient
struct DrinkWaterClient {
    var isExistDocument: @Sendable () async throws -> Bool = { false }
    var createDocument: @Sendable () async throws -> Void
    var fetchNumberOfGlasses: @Sendable () async throws -> Int = { 0 }
    var drinkWater: @Sendable () async throws -> Void
    var reset: @Sendable () async throws -> Void
}

extension DrinkWaterClient: TestDependencyKey {
    static var previewValue = Self(
        isExistDocument: {
            true
        }, 
        createDocument: {
            return
        },
        fetchNumberOfGlasses : {
            0
        },
        drinkWater: {
            return
        }, reset: {
            return
        }
    )
}

extension DrinkWaterClient: DependencyKey {
    static let liveValue = Self(
        isExistDocument: {
            try await MulimeeFirestore().isExistDocument(userId: "1")
        }, 
        createDocument: {
            try await MulimeeFirestore().createDocument(userId: "1")
        },
        fetchNumberOfGlasses: {
            try await MulimeeFirestore().fetch(userId: "1").glasses
        },
        drinkWater: {
            try await MulimeeFirestore().drink(userId: "1")
        }, reset: {
            try await MulimeeFirestore().reset(userId: "1")
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
