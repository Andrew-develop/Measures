//
//  InitialStartTapeUnitCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 20.02.2023.
//

import Foundation

final class InitialStartTapeUnitCellViewModel: PreparableViewModel, Equatable {
    let cellId: String = InitialStartTapeUnitCell.className
    let props: InitialStartTapeUnitCell.Props

    init(props: InitialStartTapeUnitCell.Props) {
        self.props = props
    }

    static func == (lhs: InitialStartTapeUnitCellViewModel, rhs: InitialStartTapeUnitCellViewModel) -> Bool {
        lhs.props.currentValue == rhs.props.currentValue
    }
}
