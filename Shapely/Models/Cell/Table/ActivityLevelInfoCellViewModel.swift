//
//  ActivityLevelInfoCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 19.02.2023.
//

import Foundation

final class ActivityLevelInfoCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = ActivityLevelInfoCell.className
    let props: ActivityLevelInfoCell.Props

    init(props: ActivityLevelInfoCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.title)
    }

    static func == (lhs: ActivityLevelInfoCellViewModel, rhs: ActivityLevelInfoCellViewModel) -> Bool {
        lhs.props.title == rhs.props.title
    }
}
