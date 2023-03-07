//
//  PhotoProgressCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import Foundation

final class PhotoProgressCellViewModel: PreparableViewModel {
    let cellId: String = PhotoProgressCell.className
    let props: PhotoProgressCell.Props

    init(props: PhotoProgressCell.Props) {
        self.props = props
    }
}
