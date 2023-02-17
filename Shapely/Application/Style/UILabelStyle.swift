//
//  UILabelStyle.swift
//  Vladlink
//
//  Created by Pavel Zorin on 21.02.2021.
//

import UIKit
extension StyleWrapper where Element == UILabel {
    static var moreLine: StyleWrapper {
        return .wrap { label, _ in
            label.numberOfLines = 0
        }
    }

    static func numberOfLines(forLines lines: Int) -> StyleWrapper {
        return .wrap { label, _ in
            label.numberOfLines = lines
        }
    }

    static var background: StyleWrapper {
        return .wrap { label, theme in
            label.backgroundColor = theme.colorPalette.background
        }
    }

    static var screenTitle: StyleWrapper {
        return .wrap { label, theme in
            label.textColor = theme.colorPalette.text
            label.font = theme.typography.header1
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
        }
    }

    static var defaultText: StyleWrapper {
        return .wrap { label, theme in
            label.textColor = theme.colorPalette.text
            label.font = theme.typography.body2
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
        }
    }
}
