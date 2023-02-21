//
//  UISegmentedControlStyle.swift
//  Shapely
//
//  Created by Andrew on 18.02.2023.
//

import UIKit
extension StyleWrapper where Element == UISegmentedControl {
    static var gender: StyleWrapper {
        return .wrap { segment, theme in
            segment.selectedSegmentIndex = 0
            segment.backgroundColor = theme.colorPalette.surface
            segment.layer.cornerRadius = Grid.sm.offset / 2
            segment.selectedSegmentTintColor = theme.colorPalette.button
            segment.insertSegment(withTitle: Gender.male.description, at: Gender.male.rawValue, animated: false)
            segment.insertSegment(withTitle: Gender.female.description, at: Gender.female.rawValue, animated: false)

            segment.setTitleTextAttributes([
                NSAttributedString.Key.font: theme.typography.body1,
                NSAttributedString.Key.foregroundColor: theme.colorPalette.text
            ], for: .normal)
        }
    }
}
