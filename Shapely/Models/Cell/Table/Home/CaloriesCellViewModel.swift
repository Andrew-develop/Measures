//
//  CaloriesCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import Foundation

final class CaloriesCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = CaloriesCell.className
    let props: CaloriesCell.Props

    init(props: CaloriesCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.calories.value)
    }

    static func == (lhs: CaloriesCellViewModel, rhs: CaloriesCellViewModel) -> Bool {
        lhs.props.calories.value == rhs.props.calories.value &&
        lhs.props.nutritions == rhs.props.nutritions &&
        lhs.props.state == rhs.props.state
    }
}
