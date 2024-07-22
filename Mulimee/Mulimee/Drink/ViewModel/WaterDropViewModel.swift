//
//  WaterDropViewModel.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/27/24.
//

import Combine
import Foundation

final class WaterDropViewModel: ObservableObject {
    @Published private(set) var waterWaveProgress: Double = 0
    let waveHeight: CGFloat = 0.1
    @Published private(set) var offset: CGFloat = 0
    private var cancellables = Set<AnyCancellable>()
    
    init(_ numberOfGlassesPublisher: AnyPublisher<Int, Never>) {
        bind(numberOfGlassesPublisher)
    }
    
    private func bind(_ numberOfGlassesPublisher: AnyPublisher<Int, Never>) {
        numberOfGlassesPublisher
            .sink { [weak self] numberOfGlasses in
                self?.waterWaveProgress = CGFloat(numberOfGlasses) / 8
            }
            .store(in: &self.cancellables)
    }
    
    func startAnimation() {
        offset = 360
    }
}
