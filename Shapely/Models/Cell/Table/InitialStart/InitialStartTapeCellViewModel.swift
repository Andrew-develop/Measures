//
//  InitialStartTapeCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 19.02.2023.
//

import Foundation

final class InitialStartTapeCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = InitialStartTapeCell.className
    let props: InitialStartTapeCell.Props

    init(props: InitialStartTapeCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.startValue)
    }

    static func == (lhs: InitialStartTapeCellViewModel, rhs: InitialStartTapeCellViewModel) -> Bool {
        lhs.props.startValue == rhs.props.startValue &&
        lhs.props.items == rhs.props.items &&
        lhs.props.measureType == rhs.props.measureType
    }
}
