//
//  WidgetInfoPack.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import Foundation

struct WidgetInfoPack: Hashable {
    let header: MainControlHeaderCellViewModel
    let viewModels: [WidgetInfoPackItem]
}

enum WidgetInfoPackItem: Hashable {
    case calories(CaloriesCellViewModel)
    case addWidget(AddWidgetCellViewModel)
    case photoProgress(PhotoProgressCellViewModel)
}
