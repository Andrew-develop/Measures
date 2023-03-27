//
//  PhotoVariantCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 25.03.2023.
//

import Foundation

final class PhotoVariantCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = PhotoVariantCell.className
    let props: PhotoVariantCell.Props

    init(props: PhotoVariantCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.id)
    }

    static func == (lhs: PhotoVariantCellViewModel, rhs: PhotoVariantCellViewModel) -> Bool {
        lhs.props.id == rhs.props.id
    }
}
