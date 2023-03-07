//
//  UIStackViewStyle.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import UIKit

extension StyleWrapper where Element == UIStackView {
    static var editingCell: StyleWrapper {
        return .wrap { stack, theme in
            stack.backgroundColor = theme.colorPalette.surface
            stack.axis = .vertical
            stack.distribution = .fill
        }
    }

    static var calorie: StyleWrapper {
        return .wrap { stack, theme in
            stack.backgroundColor = theme.colorPalette.surfaceSecondary
            stack.axis = .horizontal
            stack.distribution = .fill
            stack.layer.cornerRadius = Grid.xs.offset / 2
        }
    }

    static var nutrition: StyleWrapper {
        return .wrap { stack, theme in
            stack.backgroundColor = theme.colorPalette.surfaceSecondary
            stack.axis = .horizontal
            stack.distribution = .fillProportionally
            stack.layer.cornerRadius = Grid.xs.offset / 2
        }
    }

    static var nutritionInfo: StyleWrapper {
        return .wrap { stack, theme in
            stack.backgroundColor = theme.colorPalette.surface
            stack.axis = .horizontal
            stack.distribution = .fill
        }
    }
}
