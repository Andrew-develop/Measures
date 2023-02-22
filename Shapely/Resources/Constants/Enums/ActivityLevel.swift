//
//  ActivityLevel.swift
//  Shapely
//
//  Created by Andrew on 18.02.2023.
//

import Foundation

enum ActivityLevel: Double, CaseIterable, CustomStringConvertible {
    case bad = 1.2
    case sad = 1.375
    case good = 1.55
    case high = 1.725
    case sportsman = 1.9

    var title: String {
        switch self {
        case .bad:
            return R.string.localizable.activityLevelBadTitle()
        case .sad:
            return R.string.localizable.activityLevelSadTitle()
        case .good:
            return R.string.localizable.activityLevelGoodTitle()
        case .high:
            return R.string.localizable.activityLevelHighTitle()
        case .sportsman:
            return R.string.localizable.activityLevelSportsmanTitle()
        }
    }

    var description: String {
        switch self {
        case .bad:
            return R.string.localizable.activityLevelBadInfo()
        case .sad:
            return R.string.localizable.activityLevelSadInfo()
        case .good:
            return R.string.localizable.activityLevelGoodInfo()
        case .high:
            return R.string.localizable.activityLevelHighInfo()
        case .sportsman:
            return R.string.localizable.activityLevelSportsmanInfo()
        }
    }
}
