//
//  InitialStartParameterCell.swift
//  Shapely
//
//  Created by Andrew on 20.02.2023.
//

import UIKit
import SnapKit

final class InitialStartParameterCell: PreparableTableCell {

    private let titleLabel = with(UILabel()) {
        $0.apply(.cellTitle)
    }

    private let infoLabel = with(UILabel()) {
        $0.apply(.secondaryText)
    }

    private let itemImageView = with(UIImageView()) {
        $0.apply(.contentModeScaleToFill)
    }

    private let circleImageView = with(UIImageView()) {
        $0.apply(.contentModeScaleToFill)
        $0.image = R.image.emptyCheckbox()
    }

    private let backView = with(UIView()) {
        $0.apply([.surfaceColor, .cornerRadius(Grid.xs.offset)])
    }

    var props: InitialStartParameterCell.Props = .default {
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
        guard let model = viewModel as? InitialStartParameterCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        selectionStyle = .none
        contentView.apply(.backgroundColor)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        contentView.addGestureRecognizer(tapRecognizer)

        backView.addSubviews(itemImageView, titleLabel, infoLabel, circleImageView)
        contentView.addSubview(backView)
        makeConstraints()
    }

    private func makeConstraints() {
        backView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Grid.s.offset)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        itemImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }

        circleImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-Grid.sm.offset)
            $0.size.equalTo(CGSize(width: Grid.m.offset, height: Grid.m.offset))
            $0.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(28.0)
            $0.leading.equalTo(98.0)
            $0.trailing.equalTo(circleImageView.snp.leading).offset(Grid.s.offset)
        }

        infoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalToSuperview().offset(-Grid.s.offset)
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.parameter != newProps.parameter, let parameter = newProps.parameter {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.24
            titleLabel.attributedText = NSMutableAttributedString(
                string: parameter.title,
                attributes: [
                    NSAttributedString.Key.kern: -0.41,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]
            )
            infoLabel.attributedText = NSMutableAttributedString(
                string: parameter.description,
                attributes: [
                    NSAttributedString.Key.kern: -0.41,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]
            )
            itemImageView.image = parameter.image
        }

        if oldProps.isSelected != newProps.isSelected {
            circleImageView.image = newProps.isSelected ?
            R.image.checkbox() : R.image.emptyCheckbox()
        }
    }

    @objc private func onTap() {
        props.onTap.execute()
    }
}

extension InitialStartParameterCell {
    struct Props: Mutable {
        var parameter: TreckingParameter?
        var isSelected: Bool
        var onTap: Command

        static let `default` = Props(parameter: nil, isSelected: false, onTap: .empty)
    }
}
