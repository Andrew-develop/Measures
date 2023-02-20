//
//  InitialStartEditCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 20.02.2023.
//

import Foundation

final class InitialStartEditCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = InitialStartEditCell.className
    let props: InitialStartEditCell.Props

    init(props: InitialStartEditCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.text)
    }

    static func == (lhs: InitialStartEditCellViewModel, rhs: InitialStartEditCellViewModel) -> Bool {
        lhs.props.text == rhs.props.text
    }
}
