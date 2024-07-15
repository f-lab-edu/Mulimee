//
//  FadeInOutView.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 7/6/24.
//

import SwiftUI

struct FadeInOutView: View {
    @State private var characters: Array<String.Element>
    @State private var opacity: Double = 0
    @State private var baseTime: Double
    private var stringCount: Int {
        characters.count
    }

    init(text: String, startTime: Double) {
        characters = Array(text)
        baseTime = startTime
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(characters, id: \.self) { character in
                Text(String(character))
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .opacity(opacity)
                    .animation(.easeInOut.delay(animationDelay(for: character)),
                               value: opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + baseTime) {
                opacity = 1
            }
        }
        .onTapGesture {
            opacity = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                opacity = 1
            }
        }
    }
    
    /// 문자에 대한 애니메이션 지연 시간을 계산합니다.
    private func animationDelay(for character: Character) -> Double {
        let index = characters.firstIndex(of: character) ?? 0
        return Double(index) * 0.1
    }
}

#Preview {
    FadeInOutView(text: "물리미", startTime: 1)
}
