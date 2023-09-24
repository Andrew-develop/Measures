//
//  UIToolbarStyle.swift
//  Shapely
//
//  Created by Andrew on 18.02.2023.
//

import UIKit

extension StyleWrapper where Element == UIToolbar {
    static var primary: StyleWrapper {
        return .wrap { toolbar, _ in
            toolbar.isTranslucent = false
            toolbar.barTintColor = .tertiarySystemBackground
//            toolbar.layer.borderWidth = 1.0
//            toolbar.layer.borderColor = theme.colorPalette.border.cgColor
        }
    }
}
