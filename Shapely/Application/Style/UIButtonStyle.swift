//
//  UIButtonStyle.swift
//  Vladlink
//
//  Created by Pavel Zorin on 21.02.2021.
//

import UIKit

extension StyleWrapper where Element == UIButton {
    static var continueButton: StyleWrapper {
        return .wrap { button, theme in
            button.layer.cornerRadius = Grid.s.offset
            button.titleLabel?.font = theme.typography.body1
            button.backgroundColor = theme.colorPalette.button
            button.setTitleColor(theme.colorPalette.text, for: .normal)
        }
    }

    static var backButton: StyleWrapper {
        return .wrap { button, theme in
            button.layer.cornerRadius = Grid.s.offset
            button.backgroundColor = theme.colorPalette.surface
            button.setImage(R.image.arrowLeft(), for: .normal)
        }
    }

    static var doneButton: StyleWrapper {
        return .wrap { button, theme in
            button.backgroundColor = .tertiarySystemBackground
            button.setTitle(R.string.localizable.buttonDone(), for: .normal)
            button.setTitleColor(theme.colorPalette.button, for: .normal)
        }
    }

    static var closeButton: StyleWrapper {
        return .wrap { button, theme in
            button.backgroundColor = theme.colorPalette.background
            button.setTitle(R.string.localizable.buttonClose(), for: .normal)
            button.setTitleColor(theme.colorPalette.button, for: .normal)
        }
    }
}
