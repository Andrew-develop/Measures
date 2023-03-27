//
//  UITabBarStyle.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import UIKit

extension StyleWrapper where Element == UITabBar {
    static var main: StyleWrapper {
        return .wrap { tabBar, theme in
            tabBar.barTintColor = theme.colorPalette.button
            tabBar.tintColor = theme.colorPalette.text
            tabBar.backgroundColor = theme.colorPalette.button
        }
    }
}
