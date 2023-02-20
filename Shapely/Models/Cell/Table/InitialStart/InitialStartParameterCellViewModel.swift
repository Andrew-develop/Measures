//
//  InitialStartParameterCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 20.02.2023.
//

import Foundation

final class InitialStartParameterCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = InitialStartParameterCell.className
    let props: InitialStartParameterCell.Props

    init(props: InitialStartParameterCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.parameter?.title)
    }

    static func == (lhs: InitialStartParameterCellViewModel, rhs: InitialStartParameterCellViewModel) -> Bool {
        lhs.props.parameter == rhs.props.parameter &&
        lhs.props.isSelected == rhs.props.isSelected
    }
}
