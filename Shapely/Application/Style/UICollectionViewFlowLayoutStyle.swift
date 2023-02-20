//
//  UICollectionViewFlowLayoutStyle.swift
//  Vladlink
//
//  Created by Pavel Zorin on 20.03.2021.
//

import UIKit

extension UICollectionViewFlowLayout: Stylable {}

extension StyleWrapper where Element == UICollectionViewFlowLayout {
    static var measures: StyleWrapper {
        return .wrap { layout, _ in
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = Grid.xs.offset
        }
    }
}
