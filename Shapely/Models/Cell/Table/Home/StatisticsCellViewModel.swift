//
//  StatisticsCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 27.03.2023.
//

import Foundation

final class StatisticsCellViewModel: EditableCellViewModel, Hashable {
    let props: StatisticsCell.Props

    init(editProps: EditableCell.Props, props: StatisticsCell.Props) {
        self.props = props
        super.init(cellId: StatisticsCell.className, editProps: editProps)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.id)
    }

    static func == (lhs: StatisticsCellViewModel, rhs: StatisticsCellViewModel) -> Bool {
        lhs.props.id == rhs.props.id &&
        lhs.editProps == rhs.editProps
    }
}
