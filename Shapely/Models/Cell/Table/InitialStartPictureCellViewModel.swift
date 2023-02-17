//
//  InitialStartPictureCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 17.02.2023.
//

import Foundation

final class InitialStartPictureCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = InitialStartPictureCell.className
    let props: InitialStartPictureCell.Props

    init(props: InitialStartPictureCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.picture)
    }

    static func == (lhs: InitialStartPictureCellViewModel, rhs: InitialStartPictureCellViewModel) -> Bool {
        lhs.props.picture == rhs.props.picture
    }
}
