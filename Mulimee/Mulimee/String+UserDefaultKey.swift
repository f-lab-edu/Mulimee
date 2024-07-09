//
//  String+UserDefaultKey.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 7/6/24.
//

import Foundation

extension String {
    static var glassesOfToday: String {
        let now = Date()
        let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return df
        }()
        return dateFormatter.string(from: now)
    }
}
