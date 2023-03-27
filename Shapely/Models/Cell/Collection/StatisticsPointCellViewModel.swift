//
//  StatisticsPointCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 27.03.2023.
//

import Foundation

final class StatisticsPointCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = StatisticsPointCell.className
    let props: StatisticsPointCell.Props

    init(props: StatisticsPointCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.value)
    }

    static func == (lhs: StatisticsPointCellViewModel, rhs: StatisticsPointCellViewModel) -> Bool {
        lhs.props.title == rhs.props.title &&
        lhs.props.value == rhs.props.value &&
        lhs.props.diffrence == rhs.props.diffrence
    }
}
