//
//  PhotoTypesCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 25.03.2023.
//

import Foundation

final class PhotoTypesCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = PhotoTypesCell.className
    let props: PhotoTypesCell.Props

    init(props: PhotoTypesCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.id)
    }

    static func == (lhs: PhotoTypesCellViewModel, rhs: PhotoTypesCellViewModel) -> Bool {
        lhs.props.items == rhs.props.items
    }
}
