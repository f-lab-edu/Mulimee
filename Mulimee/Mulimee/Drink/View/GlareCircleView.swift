//
//  WaterDropView.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 6/29/24.
//

import SwiftUI

struct GlareCircleView: View {
    let opacity: CGFloat = 0.1
    let sizeConstant: CGFloat
    let offset: CGPoint
    
    var body: some View {
        Circle()
            .fill(.white.opacity(opacity))
            .frame(width: sizeConstant, height: sizeConstant)
            .offset(x: offset.x, y: offset.y)
    }
}

#Preview {
    GlareCircleView(sizeConstant: 15, offset: .init(x: -20, y: 0))
}
