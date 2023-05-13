//
//  CaloriesCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import Foundation

final class CaloriesCellViewModel: EditableCellViewModel, Hashable {
    let props: CaloriesCell.Props

    init(editProps: EditableCell.Props, props: CaloriesCell.Props) {
        self.props = props
        super.init(cellId: CaloriesCell.className, editProps: editProps)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.calories.value)
    }

    static func == (lhs: CaloriesCellViewModel, rhs: CaloriesCellViewModel) -> Bool {
        lhs.props.calories.value == rhs.props.calories.value &&
        lhs.props.nutritions == rhs.props.nutritions &&
        lhs.editProps == rhs.editProps
    }
}
