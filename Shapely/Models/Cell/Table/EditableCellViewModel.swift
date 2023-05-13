//
//  EditableCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 12.05.2023.
//

import Foundation

class EditableCellViewModel: PreparableViewModel {
    let cellId: String
    let editProps: EditableCell.Props

    init(cellId: String, editProps: EditableCell.Props) {
        self.cellId = cellId
        self.editProps = editProps
    }
}
