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

    var baseCoef: Double {
        self == .male ? 88.362 : 447.593
    }

    var weightCoef: Double {
        self == .male ? 13.397 : 9.247
    }

    var heightCoef: Double {
        self == .male ? 4.799 : 3.098
    }

    var ageCoef: Double {
        self == .male ? 5.677 : 4.330
    }
}
