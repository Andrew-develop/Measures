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

    static func hidden(_ value: Bool) -> StyleWrapper {
        return .wrap { button, _ in
            button.isHidden = value
        }
    }
}
