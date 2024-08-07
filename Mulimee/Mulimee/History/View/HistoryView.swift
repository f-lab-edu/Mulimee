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
                        .fontWeight(.heavy)
                    
                    Spacer()
                }
                .padding()
                
                Grid(horizontalSpacing: 5, verticalSpacing: 5) {
                    ForEach(0..<(viewModel.histories.count + 4) / 5, id: \.self) { rowIndex in
                        GridRow {
                            ForEach(0..<5) { columnIndex in
                                let index = rowIndex * 5 + columnIndex
                                if index < viewModel.histories.count {
                                    HistoryItem(history: viewModel.histories[index])
                                        .aspectRatio(1, contentMode: .fit)
                                } else {
                                    EmptyView()
                                }
                            }
                        }
                    }
                }
                .padding(5)
                
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
