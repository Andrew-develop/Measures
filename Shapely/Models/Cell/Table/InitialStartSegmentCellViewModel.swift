//
//  InitialStartSegmentCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 18.02.2023.
//

import Foundation

final class InitialStartSegmentCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = InitialStartSegmentCell.className
    let props: InitialStartSegmentCell.Props

    init(props: InitialStartSegmentCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(-1)
    }

    static func == (lhs: InitialStartSegmentCellViewModel, rhs: InitialStartSegmentCellViewModel) -> Bool {
        lhs.props.selectedSegmentIndex == rhs.props.selectedSegmentIndex
    }
}
