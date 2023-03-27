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
            layout.minimumLineSpacing = Grid.xs.offset
        }
    }

    static var photoCollage: StyleWrapper {
        return .wrap { layout, _ in
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = Grid.xs.offset
            layout.itemSize = CGSize(width: 120.0, height: 210.0)
        }
    }

    static var statistics: StyleWrapper {
        return .wrap { layout, _ in
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = Grid.s.offset
            layout.minimumInteritemSpacing = Grid.s.offset
            layout.itemSize = CGSize(width: 86.0, height: 68.0)
            layout.sectionInset = UIEdgeInsets(top: Grid.s.offset, left: Grid.s.offset, bottom: 0, right: 0)
        }
    }
}
