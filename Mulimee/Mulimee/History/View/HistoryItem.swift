//
//  HistoryItem.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 8/5/24.
//

import SwiftUI

struct HistoryItem: View {
    let history: History
    let itemSize: CGFloat
    
    private var dayString: String {
        let day = Calendar.current.component(.day, from: history.date)
        return "\(day)"
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(dayString)
                    .font(.title2)
                Spacer()
            }
            HStack {
                Spacer()
                Text(String(format: "%.0fml", history.mililiter))
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
        .frame(width: itemSize, height: itemSize)
        .background(Color.white)
        .cornerRadius(5)
        .shadow(radius: 2)
    }
}

#Preview {
    HistoryItem(history: .mock, itemSize: 50)
}
