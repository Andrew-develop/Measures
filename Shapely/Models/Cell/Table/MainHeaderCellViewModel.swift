//
//  InitialStartHeaderCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 17.02.2023.
//

import Foundation

final class MainHeaderCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = MainHeaderCell.className
    let props: MainHeaderCell.Props

    init(props: MainHeaderCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.title)
    }

    static func == (lhs: MainHeaderCellViewModel, rhs: MainHeaderCellViewModel) -> Bool {
        lhs.props.title == rhs.props.title
    }
}
