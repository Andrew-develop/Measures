//
//  StatisticsCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 27.03.2023.
//

import Foundation

final class StatisticsCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = StatisticsCell.className
    let props: StatisticsCell.Props

    init(props: StatisticsCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.id)
    }

    static func == (lhs: StatisticsCellViewModel, rhs: StatisticsCellViewModel) -> Bool {
        lhs.props.id == rhs.props.id
    }
}
