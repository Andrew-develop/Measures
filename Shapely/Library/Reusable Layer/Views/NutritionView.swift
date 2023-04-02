//
//  NutritionView.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import UIKit

final class NutritionView: UIView {
    private let titleLabel = with(UILabel()) {
        $0.apply(.footnoteNutrition)
    }

    private let colorView = with(UIView()) {
        $0.apply([.cornerRadius(Grid.xs.offset / 2)])
    }

    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)
        prepareView()
    }

    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NutritionView {
    func prepareView() {
        addSubviews(colorView, titleLabel)
        makeConstraints()
    }

    func makeConstraints() {
        colorView.snp.makeConstraints {
            $0.top.leading.bottom.lessThanOrEqualToSuperview()
            $0.size.equalTo(CGSize(width: Grid.sm.offset / 2, height: Grid.sm.offset / 2))
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(colorView.snp.centerY)
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(colorView.snp.trailing).offset(Grid.xs.offset / 2)
        }
    }

    func render(oldProps: Props, newProps: Props) {
        if oldProps.title != newProps.title {
            titleLabel.text = newProps.title
        }

        if oldProps.color != newProps.color, let color = newProps.color {
            colorView.backgroundColor = color
        }
    }
}

extension NutritionView {
    struct Props: Mutable, Equatable {
        var title: String
        var color: UIColor?

        static var `default` = Props(title: "", color: nil)

        static func == (lhs: NutritionView.Props, rhs: NutritionView.Props) -> Bool {
            lhs.title == rhs.title &&
            lhs.color == rhs.color
        }
    }
}
