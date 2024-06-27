//
//  WaterWave.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/27/24.
//

import SwiftUI

struct WaterWaveView: Shape {
    var progress: CGFloat
    // Wave Height
    var waveHeight: CGFloat
    // Initial Animation Start
    var offset: CGFloat
    
    // Enabling Animation
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: .zero)
            
            // Drawing vwaves using sine
            let progressHeight: CGFloat = (1 - progress) * rect.height
            let height = waveHeight * rect.height
            
            for value in stride(from: 0, to: rect.width, by: 2) {
                let x: CGFloat = value
                let sine: CGFloat = sin(Angle(degrees: value + offset).radians)
                let y: CGFloat = progressHeight + (height * sine)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        }
    }
}
