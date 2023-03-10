//
//  PhotoProgressCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import Foundation

final class PhotoProgressCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = PhotoProgressCell.className
    let props: PhotoProgressCell.Props

    init(props: PhotoProgressCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.firstImage)
    }

    static func == (lhs: PhotoProgressCellViewModel, rhs: PhotoProgressCellViewModel) -> Bool {
        lhs.props.firstImage == rhs.props.firstImage &&
        lhs.props.lastImage == rhs.props.lastImage
    }
}
