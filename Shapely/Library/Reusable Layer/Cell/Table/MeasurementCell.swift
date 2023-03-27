//
//  MeasurementCell.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import UIKit
import SnapKit

final class MeasurementCell: PreparableTableCell {

    private let measurementView = MeasurementView()

    var props: MeasurementCell.Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func prepare(withViewModel viewModel: PreparableViewModel?) {
        guard let model = viewModel as? MeasurementCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(measurementView)
        makeConstraints()
    }

    private func makeConstraints() {
        measurementView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Grid.xs.offset / 2)
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(contentView.snp.centerX)
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        measurementView.props = newProps.measurement

        if oldProps.positionPercent != newProps.positionPercent {
            measurementView.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview().inset(Grid.xs.offset / 2)
                $0.trailing.equalToSuperview()
                $0.leading.equalToSuperview().offset(Int(Int(contentView.frame.width) * newProps.positionPercent / 100))
            }
        }
    }
}

extension MeasurementCell {
    struct Props: Mutable {
        var positionPercent: Int
        var measurement: MeasurementView.Props

        static let `default` = Props(positionPercent: 0, measurement: .default)
    }
}
