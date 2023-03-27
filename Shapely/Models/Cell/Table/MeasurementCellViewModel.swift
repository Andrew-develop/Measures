//
//  MeasurementCellViewModel.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import Foundation

final class MeasurementCellViewModel: PreparableViewModel, Hashable {
    let cellId: String = MeasurementCell.className
    let props: MeasurementCell.Props

    init(props: MeasurementCell.Props) {
        self.props = props
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(props.measurement.title)
    }

    static func == (lhs: MeasurementCellViewModel, rhs: MeasurementCellViewModel) -> Bool {
        lhs.props.measurement == rhs.props.measurement &&
        lhs.props.positionPercent == rhs.props.positionPercent
    }
}
