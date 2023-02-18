//
//  InitialStartDataCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 18.02.2023.
//

import Foundation

final class InitialStartDataCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = InitialStartDataCell.className
    let props: InitialStartDataCell.Props

    init(props: InitialStartDataCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.title)
    }

    static func == (lhs: InitialStartDataCellViewModel, rhs: InitialStartDataCellViewModel) -> Bool {
        lhs.props.title == rhs.props.title &&
        lhs.props.isChevronHidden == rhs.props.isChevronHidden
    }
}
