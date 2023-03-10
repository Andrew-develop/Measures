//
//  CaloriesCell.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import UIKit
import SnapKit

final class CaloriesCell: PreparableTableCell {

    private let calorieLabel = with(UILabel()) {
        $0.apply(.cellTitle)
    }

    private let calorieStackView = with(UIStackView()) {
        $0.apply(.calorie)
    }

    private let calorieView = with(UIView()) {
        $0.apply([.cornerRadius(Grid.xs.offset / 2)])
    }

    private let nutritionLabel = with(UILabel()) {
        $0.apply(.cellTitle)
        $0.text = R.string.localizable.nutritionsTitle()
    }

    private let nutritionButton = with(UIButton()) {
        $0.setImage(R.image.question(), for: .normal)
    }

    private let nutritionStackView = with(UIStackView()) {
        $0.apply(.nutrition)
    }

    private let nutritionInfoStackView = with(UIStackView()) {
        $0.apply(.nutritionInfo)
    }

    private let backView = with(UIView()) {
        $0.apply([.surfaceColor, .cornerRadius(Grid.xs.offset)])
    }

    private let editingStackView = with(EditingCellStack()) {
        ($0 as UIView).apply(.cornerRadius(Grid.xs.offset))
    }

    var props: CaloriesCell.Props = .default {
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
        guard let model = viewModel as? CaloriesCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        selectionStyle = .none
        contentView.apply(.backgroundColor)

        backView.addSubviews(calorieLabel, calorieStackView, nutritionLabel, nutritionButton,
                             nutritionStackView, nutritionInfoStackView)
        contentView.addSubviews(backView, editingStackView)

        makeConstraints()
    }

    private func makeConstraints() {
        backView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Grid.s.offset)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        calorieLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(Grid.s.offset)
        }

        calorieStackView.snp.makeConstraints {
            $0.top.equalTo(calorieLabel.snp.bottom).offset(Grid.xs.offset)
            $0.height.equalTo(Grid.xs.offset)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
        }

        nutritionLabel.snp.makeConstraints {
            $0.top.equalTo(calorieStackView.snp.bottom).offset(Grid.s.offset)
            $0.leading.equalToSuperview().inset(Grid.s.offset)
        }

        nutritionButton.snp.makeConstraints {
            $0.centerY.equalTo(nutritionLabel.snp.centerY)
            $0.leading.equalTo(nutritionLabel.snp.trailing).offset(Grid.xs.offset / 2)
        }

        nutritionStackView.snp.makeConstraints {
            $0.top.equalTo(nutritionLabel.snp.bottom).offset(Grid.xs.offset)
            $0.height.equalTo(Grid.xs.offset)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
        }

        nutritionStackView.snp.makeConstraints {
            $0.top.equalTo(nutritionStackView.snp.bottom).offset(Grid.xs.offset)
            $0.height.equalTo(14.0)
            $0.leading.trailing.bottom.equalToSuperview().inset(Grid.s.offset)
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.calories != newProps.calories {
            showCurrentValue(newProps.calories.value, from: newProps.calories.base)
        }
    }

    private func showCurrentValue(_ value: Int, from base: Int) {
        let valueText = NSMutableAttributedString(
            string: String(value) + " " + Measure.kcal.rawValue,
            attributes: [
                NSAttributedString.Key.font: DefaultTypography.header2,
                NSAttributedString.Key.foregroundColor: DefaultColorPalette.text
            ])
        let space = NSAttributedString(string: " ")
        let measureText = NSAttributedString(
            string: "из \(base)",
            attributes: [
                NSAttributedString.Key.font: DefaultTypography.body2,
                NSAttributedString.Key.foregroundColor: DefaultColorPalette.textSecondary
            ])
        valueText.append(space)
        valueText.append(measureText)
        calorieLabel.attributedText = valueText
    }
}

// swiftlint:disable large_tuple

extension CaloriesCell {
    struct Props: Mutable {
        var state: State
        var calories: (value: Int, base: Int)
        var nutritions: (p: Int, f: Int, c: Int)

        static let `default` = Props(state: .base, calories: (value: 0, base: 0),
        nutritions: (p: 0, f: 0, c: 0))

        enum State {
            case base
            case editing
        }
    }
}
