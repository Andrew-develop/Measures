//
//  MainControlHeaderCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import Foundation

final class MainControlHeaderCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = MainControlHeaderCell.className
    let props: MainControlHeaderCell.Props

    init(props: MainControlHeaderCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.title)
    }

    static func == (lhs: MainControlHeaderCellViewModel, rhs: MainControlHeaderCellViewModel) -> Bool {
        lhs.props.title == rhs.props.title
    }
}
