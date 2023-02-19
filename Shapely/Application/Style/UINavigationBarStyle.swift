//
//  UINavigationBarStyle.swift
//  Vladlink
//
//  Created by Pavel Zorin on 22.02.2021.
//

import UIKit

extension StyleWrapper where Element == UINavigationBar {
    static func title(_ backgroundColor: UIColor, font: UIFont) -> StyleWrapper {
        return .wrap { bar, theme in
            let appearance = UINavigationBarAppearance()
            appearance.largeTitleTextAttributes = [
                .foregroundColor: theme.colorPalette.text,
                .font: font
            ]
            appearance.backgroundColor = backgroundColor
            bar.standardAppearance = appearance
            bar.compactAppearance = appearance
            bar.scrollEdgeAppearance = appearance
        }
    }
}
