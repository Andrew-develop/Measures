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

    static func mapEdit(text: String,
                        onTap: Command) -> InitialStartEditCellViewModel {
        InitialStartEditCellViewModel(
            props: InitialStartEditCell.Props(
                text: text,
                onTap: onTap
            )
        )
    }

    static func mapTape(startValue: Double,
                        measureType: Measure,
                        interval: Range<Int>,
                        onChanged: CommandWith<Double>) -> InitialStartTapeCellViewModel {
        InitialStartTapeCellViewModel(
            props: InitialStartTapeCell.Props(
                startValue: startValue,
                measureType: measureType,
                range: interval,
                items: interval.map { value in
                    InitialStartTapeUnitCellViewModel(
                        props: InitialStartTapeUnitCell.Props(
                            currentValue: String(value)
                        )
                    )
                },
                onChanged: onChanged
            )
        )
    }
}
