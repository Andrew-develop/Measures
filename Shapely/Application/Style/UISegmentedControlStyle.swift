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
            segment.backgroundColor = theme.colorPalette.surface
            segment.layer.cornerRadius = Grid.sm.offset / 2
            segment.selectedSegmentTintColor = theme.colorPalette.button
            segment.insertSegment(with: UIImage.textEmbededImage(
                image: Gender.male.icon,
                string: Gender.male.description,
                color: DefaultColorPalette.text) ?? UIImage(), at: Gender.male.rawValue, animated: false)
            segment.insertSegment(with: UIImage.textEmbededImage(
                image: Gender.female.icon,
                string: Gender.female.description,
                color: DefaultColorPalette.text) ?? UIImage(), at: Gender.female.rawValue, animated: false)
            segment.layoutIfNeeded()
            segment.subviews.forEach { view in
                guard let imageView = view as? UIImageView,
                      !imageView.subviews.isEmpty,
                      imageView.image != nil else { return }
                imageView.alpha = 0
            }
        }
    }

    static var interval: StyleWrapper {
        return .wrap { segment, theme in
            segment.backgroundColor = theme.colorPalette.surface
            segment.layer.cornerRadius = Grid.sm.offset / 2
            segment.selectedSegmentTintColor = theme.colorPalette.button
            StatInterval.allCases.forEach { value in
                segment.insertSegment(withTitle: value.description, at: value.rawValue, animated: false)
            }
        }
    }
}
