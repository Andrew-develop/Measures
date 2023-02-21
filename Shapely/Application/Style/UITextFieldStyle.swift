//
//  UITextFieldStyle.swift
//  Vladlink
//
//  Created by Pavel Zorin on 25.02.2021.
//

import UIKit

extension StyleWrapper where Element == UITextField {
    static var numeric: StyleWrapper {
        return .wrap { textField, theme in
            textField.backgroundColor = theme.colorPalette.surface
            textField.keyboardType = .asciiCapableNumberPad
        }
    }
}
