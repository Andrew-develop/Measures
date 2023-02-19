//
//  ActivityLevelInfoCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 19.02.2023.
//

import Foundation

final class ActivityLevelInfoCellViewModel: PreparableViewModel {
    let cellId: String = ActivityLevelInfoCell.className
    let props: ActivityLevelInfoCell.Props

    init(props: ActivityLevelInfoCell.Props) {
        self.props = props
    }
}
