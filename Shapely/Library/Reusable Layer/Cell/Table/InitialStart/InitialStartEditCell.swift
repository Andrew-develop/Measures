//
//  InitialStartEditCell.swift
//  Shapely
//
//  Created by Andrew on 20.02.2023.
//

import UIKit
import SnapKit

final class InitialStartEditCell: PreparableTableCell {

    private let titleLabel = with(UILabel()) {
        $0.apply(.editCell)
    }

    private let iconImageView = with(UIImageView()) {
        $0.apply(.contentModeScaleToFill)
        $0.image = R.image.edit()
    }

    var props: InitialStartEditCell.Props = .default {
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
        guard let model = viewModel as? InitialStartEditCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        selectionStyle = .none
        contentView.apply(.backgroundColor)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        contentView.addGestureRecognizer(tapRecognizer)

        contentView.addSubviews(titleLabel, iconImageView)
        makeConstraints()
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Grid.sm.offset)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-Grid.xs.offset)
        }

        iconImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(CGSize(width: Grid.sm.offset, height: Grid.sm.offset))
            $0.leading.equalTo(titleLabel.snp.trailing).offset(Grid.xs.offset)
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.text != newProps.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 0.96
            titleLabel.attributedText = NSMutableAttributedString(
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

extension InitialStartEditCell {
    struct Props: Mutable {
        var text: String
        var onTap: Command

        static let `default` = Props(text: "", onTap: .empty)
    }
}
