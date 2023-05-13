//
//  MenuItem.swift
//  Shapely
//
//  Created by Andrew on 12.05.2023.
//

import UIKit

enum MenuItem {
    case control
    case settings

    var icon: UIImage? {
        switch self {
        case .control:
            return R.image.controlEdit()
        case .settings:
            return R.image.gear()
        }
    }

    var title: String {
        switch self {
        case .control:
            return "Изменить виджеты"
        case .settings:
            return "Настройки"
        }
    }
}
