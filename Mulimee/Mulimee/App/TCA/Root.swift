//
//  Root.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 8/29/24.
//

import ComposableArchitecture

@Reducer
struct Root {
    @ObservableState
    struct State {
        var isFirstLaunching = true
        var drinkWater = DrinkWater.State()
    }
    
    @Dependency(\.continuousClock) var clock
    private enum CancelID { case timer }
    
    enum Action {
        case onAppear
        case timerTicked
        case drinkWater(DrinkWater.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    for await _ in self.clock.timer(interval: .seconds(2)) {
                        await send(.timerTicked, animation: .interpolatingSpring(stiffness: 3000, damping: 40))
                    }
                }
                .cancellable(id: CancelID.timer, cancelInFlight: true)
                
            case .timerTicked:
                state.isFirstLaunching = false
                return .cancel(id: CancelID.timer)
                
            case .drinkWater:
                return .none
            }
        }
        
        Scope(state: \.drinkWater, action: \.drinkWater) {
            DrinkWater()
        }
    }
}
