//
//  InitialStartMapper.swift
//  Shapely
//
//  Created by Andrew on 18.02.2023.
//

import UIKit

enum InitialStartMapper {
    static func mapHeader(with title: String) -> MainHeaderCellViewModel {
        MainHeaderCellViewModel(
            props: MainHeaderCell.Props(
                title: title
            )
        )
    }

    static func mapTitle(with text: String) -> InitialStartTitleCellViewModel {
        InitialStartTitleCellViewModel(
            props: InitialStartTitleCell.Props(
                title: text
            )
        )
    }

    static func mapText(with value: String) -> InitialStartTextCellViewModel {
        InitialStartTextCellViewModel(
            props: InitialStartTextCell.Props(
                title: value
            )
        )
    }

    static func mapPicture(with image: UIImage?) -> InitialStartPictureCellViewModel {
        InitialStartPictureCellViewModel(
            props: InitialStartPictureCell.Props(
                picture: image
            )
        )
    }

    static func mapSegment(with gender: Gender,
                           onSegmentChanged: CommandWith<Int>) -> InitialStartSegmentCellViewModel {
        InitialStartSegmentCellViewModel(
            props: InitialStartSegmentCell.Props(
                selectedSegmentIndex: gender.rawValue,
                onSegmentChanged: onSegmentChanged
            )
        )
    }

    static func mapData(title: String,
                        isChevronHidden: Bool,
                        onTap: Command) -> InitialStartDataCellViewModel {
        InitialStartDataCellViewModel(
            props: InitialStartDataCell.Props(
                title: title,
                isChevronHidden: isChevronHidden,
                onTap: onTap
            )
        )
    }
}
