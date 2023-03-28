//
//  Nutritions.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import UIKit

enum Nutritions: String, CaseIterable {
    case proteins
    case fat
    case carbon

    var indicatorColor: UIColor? {
        switch self {
        case .proteins:
            return R.color.accentBlue()
        case .fat:
            return R.color.accentYellow()
        case .carbon:
            return R.color.accentPurple()
        }
    }

    var title: String {
        switch self {
        case .proteins:
            return R.string.localizable.nutritionsProteins()
        case .fat:
            return R.string.localizable.nutritionsFat()
        case .carbon:
            return R.string.localizable.nutritionsCarbon()
        }
    }
}
