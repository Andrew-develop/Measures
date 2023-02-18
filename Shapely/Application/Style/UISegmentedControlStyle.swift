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
            segment.insertSegment(with: Gender.male.icon, at: Gender.male.rawValue, animated: false)
            segment.insertSegment(with: Gender.female.icon, at: Gender.female.rawValue, animated: false)

            segment.setTitle(Gender.male.description, forSegmentAt: Gender.male.rawValue)
            segment.setTitle(Gender.female.description, forSegmentAt: Gender.female.rawValue)
            segment.setTitleTextAttributes([
                NSAttributedString.Key.font: theme.typography.body1,
                NSAttributedString.Key.foregroundColor: theme.colorPalette.text
            ], for: .normal)
        }
    }
}
