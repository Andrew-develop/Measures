//
//  ActivityLevelInfoCell.swift
//  Shapely
//
//  Created by Andrew on 19.02.2023.
//

import UIKit
import SnapKit

final class ActivityLevelInfoCell: PreparableTableCell {

    private let titleLabel = with(UILabel()) {
        $0.apply(.cellTitle)
    }

    private let infoLabel = with(UILabel()) {
        $0.apply(.secondaryText)
    }

    private let backView = with(UIView()) {
        $0.apply([.surfaceColor, .cornerRadius(Grid.xs.offset)])
    }

    var props: ActivityLevelInfoCell.Props = .default {
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
        guard let model = viewModel as? ActivityLevelInfoCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        selectionStyle = .none
        contentView.apply(.backgroundColor)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        contentView.addGestureRecognizer(tapRecognizer)

        backView.addSubviews(titleLabel, infoLabel)
        contentView.addSubview(backView)
        makeConstraints()
    }

    private func makeConstraints() {
        backView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Grid.s.offset)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(Grid.s.offset)
        }

        infoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Grid.xs.offset / 2)
            $0.leading.trailing.bottom.equalToSuperview().inset(Grid.s.offset)
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

        if oldProps.text != newProps.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.24
            infoLabel.attributedText = NSMutableAttributedString(
                string: newProps.text,
                attributes: [
                    NSAttributedString.Key.kern: -0.41,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]
            )
        }
    }

    @objc private func onTap() {
        props.onTap.execute()
    }
}

extension ActivityLevelInfoCell {
    struct Props: Mutable {
        var title: String
        var text: String
        var onTap: Command

        static let `default` = Props(title: "", text: "", onTap: .empty)
    }
}
