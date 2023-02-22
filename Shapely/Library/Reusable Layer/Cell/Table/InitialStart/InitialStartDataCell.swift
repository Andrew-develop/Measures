//
//  InitialStartDataCell.swift
//  Shapely
//
//  Created by Andrew on 18.02.2023.
//

import UIKit
import SnapKit

final class InitialStartDataCell: PreparableTableCell {

    private let titleLabel = with(UILabel()) {
        $0.apply(.defaultText)
    }

    private let chevronImageView = with(UIImageView()) {
        $0.apply(.contentModeScaleToFill)
        $0.image = R.image.chevronDown()
    }

    private let backView = with(UIView()) {
        $0.apply([.surfaceColor, .cornerRadius(Grid.xs.offset)])
    }

    var props: InitialStartDataCell.Props = .default {
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
        guard let model = viewModel as? InitialStartDataCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        selectionStyle = .none
        contentView.apply(.backgroundColor)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        contentView.addGestureRecognizer(tapRecognizer)

        backView.addSubviews(titleLabel, chevronImageView)
        contentView.addSubview(backView)
        makeConstraints()
    }

    private func makeConstraints() {
        backView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Grid.xs.offset)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        chevronImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: Grid.sm.offset, height: Grid.sm.offset))
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-Grid.xs.offset)
        }

        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Grid.sm.offset / 2)
            $0.leading.equalToSuperview().offset(Grid.s.offset)
            $0.trailing.equalTo(chevronImageView.snp.leading).offset(-Grid.xs.offset)
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.title != newProps.title {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.24
            titleLabel.attributedText = NSMutableAttributedString(
                string: newProps.title,
                attributes: [
                    NSAttributedString.Key.kern: -0.41,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]
            )
        }

        if oldProps.isSelected != newProps.isSelected {
            newProps.isSelected ? (backView.apply(.cellBorder)) : (backView.layer.borderWidth = 0)
        }

        chevronImageView.isHidden = newProps.isChevronHidden
    }

    @objc private func onTap() {
        props.onTap.execute()
    }
}

extension InitialStartDataCell {
    struct Props: Mutable {
        var title: String
        var isChevronHidden: Bool
        var isSelected: Bool
        var onTap: Command

        static let `default` = Props(title: "", isChevronHidden: true, isSelected: false, onTap: .empty)
    }
}
