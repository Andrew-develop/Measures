//
//  DayPhotosCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 12.05.2023.
//

import Foundation

final class DayPhotosCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = DayPhotosCell.className
    let props: DayPhotosCell.Props

    init(props: DayPhotosCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.firstImage)
    }

    static func == (lhs: DayPhotosCellViewModel, rhs: DayPhotosCellViewModel) -> Bool {
        lhs.props.firstImage == rhs.props.firstImage &&
        lhs.props.secondImage == rhs.props.secondImage &&
        lhs.props.thirdImage == rhs.props.thirdImage
    }
}
