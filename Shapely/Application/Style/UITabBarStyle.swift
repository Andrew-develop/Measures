//
//  UITabBarStyle.swift
//  Shapely
//
//  Created by Andrew on 06.05.2023.
//

import UIKit

extension StyleWrapper where Element == UITabBar {
    static var photoEdit: StyleWrapper {
        return .wrap { tabBar, theme in
            tabBar.isTranslucent = false
            tabBar.barTintColor = theme.colorPalette.background
            tabBar.tintColor = theme.colorPalette.text
            tabBar.shadowImage = UIImage(color: .clear)
            tabBar.backgroundImage = UIImage(color: theme.colorPalette.background)
            tabBar.backgroundColor = theme.colorPalette.background
        }
    }
}
