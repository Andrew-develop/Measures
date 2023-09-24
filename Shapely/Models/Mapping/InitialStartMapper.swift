//
//  InitialStartMapper.swift
//  Shapely
//
//  Created by Andrew on 18.02.2023.
//

import UIKit

enum InitialStartMapper {
    static func mapTape(range: Range<Int>) -> [InitialStartTapeUnitCellViewModel] {
        range.map { value in
            InitialStartTapeUnitCellViewModel(
                props: .init(currentValue: String(value))
            )
        }
    }
}
