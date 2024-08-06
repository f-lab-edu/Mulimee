//
//  HistoryView.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 8/4/24.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var viewModel: HistoryViewModel
    
    var body: some View {
        ZStack {
            Color(.fogMist)
                .ignoresSafeArea(edges: [.top])
            
            VStack {
                HStack {
                    Text(viewModel.dateString)
                        .font(.title)
                    
                    Spacer()
                }
                .padding()
                
                GeometryReader { geometry in
                    let itemSize = geometry.size.width / 5 - 10
                    
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 5), spacing: 5) {
                        ForEach(viewModel.histories, id: \.self) { history in
                            HistoryItem(history: history, itemSize: itemSize)
                        }
                    }
                    .padding(5)
                }
                
                Spacer()
            }
        }
        .task {
            await viewModel.requestAuthorization()
            await viewModel.fetchHistores()
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(HistoryViewModel())
}
