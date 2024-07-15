//
//  UserDefaults+AppGroup.swift
//  Mulimee
//
//  Created by Kyeongmo Yang on 7/6/24.
//

import Foundation

extension UserDefaults {
    static var appGroup: UserDefaults {
        let appGroupId = "group.gaeng2y.mulimee"
        guard let appGroupUserDefaults = UserDefaults(suiteName: appGroupId) else {
            fatalError("Undefined App Group, Please check capabilities")
        }
        return appGroupUserDefaults
    }
}
