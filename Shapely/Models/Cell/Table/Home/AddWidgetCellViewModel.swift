//
//  AddWidgetCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import Foundation

final class AddWidgetCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = AddWidgetCell.className
    let props: AddWidgetCell.Props

    init(props: AddWidgetCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(-1)
    }

    static func == (lhs: AddWidgetCellViewModel, rhs: AddWidgetCellViewModel) -> Bool {
        true
    }
}
