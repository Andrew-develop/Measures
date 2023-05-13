//
//  PhotoEditItem.swift
//  Shapely
//
//  Created by Andrew on 01.05.2023.
//

import UIKit

enum PhotoEditItem: Int, CaseIterable {
    case crop = 0
    case rotate = 1
    case text = 2
    case draw = 3

    var icon: UIImage? {
        switch self {
        case .crop:
            return R.image.editorCrop()
        case .rotate:
            return R.image.editorRotate()
        case .text:
            return R.image.editorText()
        case .draw:
            return R.image.editorPencil()
        }
    }

    func createButton() -> UITabBarItem {
        let item = UITabBarItem()
        item.image = icon
        item.tag = rawValue
        return item
    }
}
