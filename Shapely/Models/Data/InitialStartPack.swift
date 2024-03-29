//
//  InitialStartPack.swift
//  Shapely
//
//  Created by Andrew on 17.02.2023.
//

import Foundation

struct InitialStartPack: Hashable {
    let header: MainHeaderCellViewModel
    let viewModels: [InitialStartPackItem]
}

enum InitialStartPackItem: Hashable {
    case text(InitialStartTextCellViewModel)
    case picture(InitialStartPictureCellViewModel)
    case segment(InitialStartSegmentCellViewModel)
    case title(InitialStartTitleCellViewModel)
    case data(InitialStartDataCellViewModel)
    case parameter(InitialStartParameterCellViewModel)
    case edit(InitialStartEditCellViewModel)
    case tape(InitialStartTapeCellViewModel)
}
