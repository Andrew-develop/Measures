//
//  UIView_addSubviews.swift
//  Vladlink
//
//  Created by Pavel Zorin on 21.02.2021.
//

import UIKit

extension UIView {
    public func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
