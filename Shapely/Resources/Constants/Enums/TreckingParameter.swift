//
//  TreckingParameters.swift
//  Shapely
//
//  Created by Andrew on 18.02.2023.
//

import UIKit

enum TreckingParameter: Int, CaseIterable, CustomStringConvertible {
    case neck
    case shoulders
    case chest
    case biceps
    case waist
    case forearm
    case wrist
    case stomach
    case pelvis
    case hip
    case shin
    case ankle

    var title: String {
        switch self {
        case .neck:
            return R.string.localizable.treckingParameterNeckTitle()
        case .chest:
            return R.string.localizable.treckingParameterChestTitle()
        case .biceps:
            return R.string.localizable.treckingParameterBicepsTitle()
        case .waist:
            return R.string.localizable.treckingParameterWaistTitle()
        case .pelvis:
            return R.string.localizable.treckingParameterPelvisTitle()
        case .shoulders:
            return R.string.localizable.treckingParameterShouldersTitle()
        case .forearm:
            return R.string.localizable.treckingParameterForearmTitle()
        case .wrist:
            return R.string.localizable.treckingParameterWristTitle()
        case .stomach:
            return R.string.localizable.treckingParameterStomachTitle()
        case .hip:
            return R.string.localizable.treckingParameterHipTitle()
        case .shin:
            return R.string.localizable.treckingParameterShinTitle()
        case .ankle:
            return R.string.localizable.treckingParameterAnkleTitle()
        }
    }

    var description: String {
        switch self {
        case .neck:
            return R.string.localizable.treckingParameterNeckInfo()
        case .chest:
            return R.string.localizable.treckingParameterChestInfo()
        case .biceps:
            return R.string.localizable.treckingParameterBicepsInfo()
        case .waist:
            return R.string.localizable.treckingParameterWaistInfo()
        case .pelvis:
            return R.string.localizable.treckingParameterPelvisInfo()
        case .shoulders:
            return R.string.localizable.treckingParameterShouldersInfo()
        case .forearm:
            return R.string.localizable.treckingParameterForearmInfo()
        case .wrist:
            return R.string.localizable.treckingParameterWristInfo()
        case .stomach:
            return R.string.localizable.treckingParameterStomachInfo()
        case .hip:
            return R.string.localizable.treckingParameterHipInfo()
        case .shin:
            return R.string.localizable.treckingParameterShinInfo()
        case .ankle:
            return R.string.localizable.treckingParameterAnkleInfo()
        }
    }

    var image: UIImage? {
        switch self {
        case .neck:
            return R.image.neck()
        case .chest:
            return R.image.chest()
        case .biceps:
            return R.image.biceps()
        case .waist:
            return R.image.waist()
        case .pelvis:
            return R.image.pelvis()
        case .shoulders:
            return R.image.shoulders()
        case .forearm:
            return R.image.forearm()
        case .wrist:
            return R.image.wrist()
        case .stomach:
            return R.image.stomach()
        case .hip:
            return R.image.hip()
        case .shin:
            return R.image.shin()
        case .ankle:
            return R.image.ankle()
        }
    }

    var positionPercent: Int {
        switch self {
        case .neck:
            return 45
        case .shoulders:
            return 55
        case .chest:
            return 65
        case .biceps:
            return 70
        case .waist:
            return 70
        case .forearm:
            return 65
        case .wrist:
            return 65
        case .stomach:
            return 60
        case .pelvis:
            return 55
        case .hip:
            return 50
        case .shin:
            return 45
        case .ankle:
            return 45
        }
    }
}
