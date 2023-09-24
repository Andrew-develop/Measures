//
//  UICollectionViewStyle.swift
//  Vladlink
//
//  Created by Pavel Zorin on 20.03.2021.
//

import UIKit

extension StyleWrapper where Element == UICollectionView {
    static var measures: StyleWrapper {
        return .wrap { collection, theme in
            collection.backgroundColor = theme.colorPalette.background
            collection.showsHorizontalScrollIndicator = false
        }
    }
}
