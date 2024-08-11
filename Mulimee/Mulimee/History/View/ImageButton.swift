//
//  ImageButton.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 8/6/24.
//

import SwiftUI

struct ImageButton: View {
    let imageName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 30, height: 30)
        }
    }
}
