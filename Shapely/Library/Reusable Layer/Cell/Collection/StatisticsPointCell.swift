//
//  StatisticsPointCell.swift
//  Shapely
//
//  Created by Andrew on 27.03.2023.
//

import UIKit
import SnapKit

final class StatisticsPointCell: PreparableCollectionCell {

    private let titleLabel = with(UILabel()) {
        $0.apply(.statisticsPointTitle)
    }

    private let valueLabel = with(UILabel()) {
        $0.apply(.statisticsPoint)
    }

    private let diffrenceLabel = UILabel()

    var props: StatisticsPointCell.Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func prepare(withViewModel viewModel: PreparableViewModel?) {
        guard let model = viewModel as? StatisticsPointCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        contentView.apply(.surfaceColor)

        contentView.addSubviews(titleLabel, valueLabel, diffrenceLabel)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        contentView.addGestureRecognizer(recognizer)

        makeConstraints()
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }

        valueLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }

        diffrenceLabel.snp.makeConstraints {
            $0.top.equalTo(valueLabel.snp.bottom).offset(Grid.xs.offset / 4)
            $0.leading.bottom.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.title != newProps.title {
            titleLabel.text = newProps.title
        }

        if oldProps.value != newProps.value {
            valueLabel.text = newProps.value
        }

        if oldProps.diffrence != newProps.diffrence {
            let valueText = NSMutableAttributedString(
                string: "\(newProps.diffrence >= 0 ? "+" : "")\(newProps.diffrence) \(newProps.measure.rawValue)",
                attributes: [
                    NSAttributedString.Key.font: DefaultTypography.footnote,
                    NSAttributedString.Key.foregroundColor: newProps.diffrence >= 0 ?
                        .green : DefaultColorPalette.button
                ])
            let space = NSAttributedString(string: " ")
            let measureText = NSAttributedString(
                string: newProps.interval,
                attributes: [
                    NSAttributedString.Key.font: DefaultTypography.footnote,
                    NSAttributedString.Key.foregroundColor: DefaultColorPalette.textSecondary
                ])
            valueText.append(space)
            valueText.append(measureText)
            diffrenceLabel.attributedText = valueText
        }
    }

    @objc private func onTap() {
        props.onTap.execute()
    }
}

extension StatisticsPointCell {
    struct Props: Mutable {
        var title: String
        var value: String
        var diffrence: Double
        var interval: String
        var measure: Measure
        var onTap: Command

        static let `default` = Props(title: "", value: "", diffrence: -1, interval: "", measure: .sm, onTap: .empty)
    }
}
