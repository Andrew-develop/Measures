//
//  Gender.swift
//  Shapely
//
//  Created by Andrew on 18.02.2023.
//

import UIKit

enum Gender: Int, CustomStringConvertible {
    case male
    case female

    var description: String {
        switch self {
        case .male:
            return R.string.localizable.genderMale()
        case .female:
            return R.string.localizable.genderFemale()
        }
    }

    var icon: UIImage? {
        switch self {
        case .male:
            return R.image.male()
        case .female:
            return R.image.female()
        }
    }
}
