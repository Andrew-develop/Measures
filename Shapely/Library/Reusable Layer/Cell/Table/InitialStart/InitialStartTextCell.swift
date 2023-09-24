//
//  InitialStartTextCell.swift
//  Shapely
//
//  Created by Andrew on 17.02.2023.
//

import UIKit
import SnapKit

final class InitialStartTextCell: PreparableTableCell {

    private let titleLabel = with(UILabel()) {
        $0.apply(.defaultText)
    }

    var props: InitialStartTextCell.Props = .default {
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
        guard let model = viewModel as? InitialStartTextCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        selectionStyle = .none
        contentView.apply(.backgroundColor)
        contentView.addSubview(titleLabel)
        makeConstraints()
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Grid.s.offset)
            $0.leading.trailing.bottom.equalToSuperview()
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
    }
}

extension InitialStartTextCell {
    struct Props: Mutable {
        var title: String

        static let `default` = Props(title: "")
    }
}
