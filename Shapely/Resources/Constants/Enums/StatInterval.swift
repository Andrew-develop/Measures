//
//  StatInterval.swift
//  Shapely
//
//  Created by Andrew on 24.04.2023.
//

import Foundation

enum StatInterval: Int, CaseIterable, CustomStringConvertible {
    case oneMonth
    case threeMonth
    case halfYear
    case year

    var description: String {
        switch self {
        case .oneMonth:
            return "1 мес"
        case .threeMonth:
            return "3 мес"
        case .halfYear:
            return "6 мес"
        case .year:
            return "1 год"
        }
    }
}
