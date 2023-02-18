//
//  UserTarget.swift
//  Shapely
//
//  Created by Andrew on 18.02.2023.
//

import Foundation

enum UserTarget: CaseIterable, CustomStringConvertible {
    case loseWeight
    case saveWeight
    case gainWeight

    var description: String {
        switch self {
        case .loseWeight:
            return R.string.localizable.userTargetLoseWeight()
        case .saveWeight:
            return R.string.localizable.userTargetSaveWeight()
        case .gainWeight:
            return R.string.localizable.userTargetGainWeight()
        }
    }
}
