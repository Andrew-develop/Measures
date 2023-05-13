//
//  PhotoProgressCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import Foundation

final class PhotoProgressCellViewModel: EditableCellViewModel, Hashable {
    let props: PhotoProgressCell.Props

    init(editProps: EditableCell.Props, props: PhotoProgressCell.Props) {
        self.props = props
        super.init(cellId: PhotoProgressCell.className, editProps: editProps)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.lastImage)
    }

    static func == (lhs: PhotoProgressCellViewModel, rhs: PhotoProgressCellViewModel) -> Bool {
        lhs.props.firstImage == rhs.props.firstImage &&
        lhs.props.lastImage == rhs.props.lastImage &&
        lhs.editProps == rhs.editProps
    }
}
