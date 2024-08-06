//
//  History.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 8/5/24.
//

import Foundation

struct History: Hashable {
    var date: Date
    var mililiter: Double
}

extension History {
    static let mock = History(date: .now, mililiter: 500.00)
}
