//
//  MainTabBarItem.swift
//  Vladlink
//
//  Created by Pavel Zorin on 13.03.2021.
//

import UIKit

enum MainTabBarItem: Int, CaseIterable {
    case home = 0
    case food = 1
    case measurement = 2
    case training = 3
    case photos = 4

    private var icon: UIImage? {
        switch self {
        case .home:
            return UIImage()
        case .food:
            return R.image.tabFood()
        case .measurement:
            return R.image.tabMeasurement()
        case .training:
            return R.image.tabTraining()
        case .photos:
            return R.image.tabPhotos()
        }
    }

    var title: String {
        switch self {
        case .home:
            return R.string.localizable.tabBarHome()
        case .food:
            return R.string.localizable.tabBarFood()
        case .measurement:
            return R.string.localizable.tabBarMeasurement()
        case .training:
            return R.string.localizable.tabBarTraining()
        case .photos:
            return R.string.localizable.tabBarPhotos()
        }
    }

    func createItem() -> UITabBarItem {
        let item = UITabBarItem(title: title, image: icon, selectedImage: icon)
        item.tag = rawValue
        return item
    }
}
