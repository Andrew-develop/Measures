//
//  AddWidgetCell.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import UIKit
import SnapKit

final class AddWidgetCell: PreparableTableCell {

    private let titleLabel = with(UILabel()) {
        $0.apply(.cellTitle)
    }

    private let addImageView = with(UIImageView()) {
        $0.apply(.contentModeScaleToFill)
    }

    private let stackView = with(UIStackView()) {
        $0.apply(.calorie)
    }

    private let backView = with(UIView()) {
        $0.apply([.backgroundColor, .cornerRadius(Grid.s.offset)])
    }

    var props: AddWidgetCell.Props = .default {
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
        guard let model = viewModel as? AddWidgetCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        selectionStyle = .none
        contentView.apply(.backgroundColor)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        contentView.addGestureRecognizer(recognizer)

        stackView.addArrangedSubview(addImageView)
        stackView.addArrangedSubview(titleLabel)
        backView.addSubviews(stackView)
        contentView.addSubviews(backView)

        makeConstraints()
    }

    private func makeConstraints() {
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func makeDashedBorder() {
        var border = CAShapeLayer()
        border.strokeColor = UIColor.black.cgColor
        border.lineDashPattern = [2, 2]
        border.frame = backView.bounds
        border.fillColor = nil
        border.path = UIBezierPath(rect: backView.bounds).cgPath
        backView.layer.addSublayer(border)
    }

    private func render(oldProps: Props, newProps: Props) {}

    @objc private func onTap() {
        props.onTap.execute()
    }
}

extension AddWidgetCell {
    struct Props: Mutable {
        var onTap: Command

        static let `default` = Props(onTap: .empty)
    }
}
