//
//  InitialStartTextCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 17.02.2023.
//

import Foundation

final class InitialStartTextCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = InitialStartTextCell.className
    let props: InitialStartTextCell.Props

    init(props: InitialStartTextCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.title)
    }

    static func == (lhs: InitialStartTextCellViewModel, rhs: InitialStartTextCellViewModel) -> Bool {
        lhs.props.title == rhs.props.title
    }
}
