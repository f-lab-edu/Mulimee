//
//  MulimeeWidgetBundle.swift
//  MulimeeWidget
//
//  Created by Kyeongmo Yang on 7/19/24.
//

import FirebaseCore
import SwiftUI
import WidgetKit

@main
struct MulimeeWidgetBundle: WidgetBundle {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Widget {
        MulimeeWidget()
    }
}
