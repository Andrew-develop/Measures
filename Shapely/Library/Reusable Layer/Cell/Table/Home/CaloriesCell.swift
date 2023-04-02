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
        $0.backgroundColor = R.color.accentGreen()
    }

    private let emptyView = UIView()

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

    private let proteinView = with(UIView()) {
        $0.backgroundColor = Nutritions.proteins.indicatorColor
    }

    private let fatView = with(UIView()) {
        $0.backgroundColor = Nutritions.fat.indicatorColor
    }

    private let carbonView = with(UIView()) {
        $0.backgroundColor = Nutritions.carbon.indicatorColor
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

        calorieStackView.addArrangedSubview(calorieView)
        calorieStackView.addArrangedSubview(emptyView)

        nutritionStackView.addArrangedSubview(proteinView)
        nutritionStackView.addArrangedSubview(fatView)
        nutritionStackView.addArrangedSubview(carbonView)

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

        nutritionInfoStackView.snp.makeConstraints {
            $0.top.equalTo(nutritionStackView.snp.bottom).offset(Grid.xs.offset)
            $0.height.equalTo(Grid.s.offset)
            $0.leading.trailing.bottom.equalToSuperview().inset(Grid.s.offset)
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.calories != newProps.calories {
            showCurrentValue(Int(newProps.calories.value), from: Int(newProps.calories.base))
            setupCalorieLine()
        }

        if oldProps.nutritionInfo != newProps.nutritionInfo {
            newProps.nutritionInfo.forEach { props in
                let nutritionView = NutritionView()
                nutritionView.props = props
                nutritionInfoStackView.addArrangedSubview(nutritionView)
            }
        }

        if oldProps.nutritions != newProps.nutritions {
            setupNutritionsLines()
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

    private func setupCalorieLine() {
        let base = props.calories.value < props.calories.base ?
        props.calories.value : props.calories.base
        let empty = props.calories.value < props.calories.base ?
        props.calories.base - props.calories.value : 0

        remakeWidth(calorieView, base / props.calories.base)
        remakeWidth(emptyView, empty / props.calories.base)
    }

    private func setupNutritionsLines() {
        let sum = props.nutritions.p + props.nutritions.c + props.nutritions.f
        Nutritions.allCases.forEach {
            switch $0 {
            case .proteins:
                remakeWidth(proteinView, props.nutritions.p / sum)
            case .carbon:
                remakeWidth(carbonView, props.nutritions.c / sum)
            case .fat:
                remakeWidth(fatView, props.nutritions.f / sum)
            }
        }
    }

    private func remakeWidth(_ currentView: UIView, _ value: CGFloat) {
        currentView.snp.remakeConstraints {
            $0.height.equalTo(Grid.xs.offset)
            $0.width.equalTo(nutritionStackView.snp.width).multipliedBy(value)
        }
    }
}

// swiftlint:disable large_tuple

extension CaloriesCell {
    struct Props: Mutable {
        var state: State
        var calories: (value: Double, base: Double)
        var nutritions: (p: Double, f: Double, c: Double)
        var nutritionInfo: [NutritionView.Props]

        static let `default` = Props(state: .base, calories: (value: 0, base: 0),
        nutritions: (p: 0, f: 0, c: 0), nutritionInfo: [])

        enum State {
            case base
            case editing
        }
    }
}
