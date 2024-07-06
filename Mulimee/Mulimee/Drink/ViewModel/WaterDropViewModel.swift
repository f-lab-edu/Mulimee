//
//  WaterDropViewModel.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/27/24.
//

import Foundation

@Observable
final class WaterDropViewModel {
    private(set) var waterWaveProgress: Double
    let waveHeight: CGFloat = 0.1
    private(set) var offset: CGFloat = 0
    
    init(waterWaveProgress: Double) {
        self.waterWaveProgress = waterWaveProgress
    }
    
    func startAnimation() {
        offset = 360
    }
}
