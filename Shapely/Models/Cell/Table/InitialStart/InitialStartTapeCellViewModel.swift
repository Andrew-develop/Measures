//
//  InitialStartTapeCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 19.02.2023.
//

import Foundation

final class InitialStartTapeCellViewModel: PreparableViewModel {
    let cellId: String = InitialStartTapeCell.className
    let props: InitialStartTapeCell.Props

    init(props: InitialStartTapeCell.Props) {
        self.props = props
    }

//    func hash(into hasher: inout Hasher) {
//        hasher.combine(props.title)
//    }
//
//    static func == (lhs: InitialStartTapeCellViewModel, rhs: InitialStartTapeCellViewModel) -> Bool {
//        lhs.props.title == rhs.props.title
//    }
}
