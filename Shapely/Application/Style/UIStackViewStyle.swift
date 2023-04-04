//
//  UIStackViewStyle.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import UIKit

extension StyleWrapper where Element == UIStackView {
    static var calorie: StyleWrapper {
        return .wrap { stack, theme in
            stack.backgroundColor = theme.colorPalette.surfaceSecondary
            stack.axis = .horizontal
            stack.distribution = .fill
            stack.layer.cornerRadius = Grid.xs.offset / 2
            stack.clipsToBounds = true
        }
    }

    static var nutrition: StyleWrapper {
        return .wrap { stack, theme in
            stack.backgroundColor = theme.colorPalette.surfaceSecondary
            stack.axis = .horizontal
            stack.distribution = .fillProportionally
            stack.layer.cornerRadius = Grid.xs.offset / 2
            stack.clipsToBounds = true
        }
    }

    static var nutritionInfo: StyleWrapper {
        return .wrap { stack, theme in
            stack.backgroundColor = theme.colorPalette.surface
            stack.axis = .horizontal
            stack.distribution = .fillProportionally
        }
    }

    static var addWidget: StyleWrapper {
        return .wrap { stack, _ in
            stack.axis = .horizontal
            stack.distribution = .fill
            stack.spacing = Grid.xs.offset
        }
    }

    static var photoProgress: StyleWrapper {
        return .wrap { stack, _ in
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            stack.spacing = Grid.xs.offset
        }
    }

    static var control: StyleWrapper {
        return .wrap { stack, _ in
            stack.axis = .vertical
            stack.distribution = .fillEqually
            stack.spacing = 1
            stack.layer.cornerRadius = Grid.xs.offset
            stack.clipsToBounds = true
        }
    }
}
