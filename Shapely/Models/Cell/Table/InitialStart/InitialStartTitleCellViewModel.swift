//
//  InitialStartTitleCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 18.02.2023.
//

import Foundation

final class InitialStartTitleCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = InitialStartTitleCell.className
    let props: InitialStartTitleCell.Props

    init(props: InitialStartTitleCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.title)
    }

    static func == (lhs: InitialStartTitleCellViewModel, rhs: InitialStartTitleCellViewModel) -> Bool {
        lhs.props.title == rhs.props.title
    }
}
