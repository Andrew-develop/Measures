//
//  UIViewStyle.swift
//  Vladlink
//
//  Created by Pavel Zorin on 21.02.2021.
//

import UIKit

extension StyleWrapper where Element == UIView {
    static func cornerRadius(_ value: CGFloat) -> StyleWrapper {
        return .wrap { button, _ in
            button.layer.cornerRadius = value
        }
    }

    static var cellBorder: StyleWrapper {
        return .wrap { view, theme in
            view.layer.borderWidth = 1.0
            view.layer.borderColor = theme.colorPalette.button.cgColor
        }
    }
}
