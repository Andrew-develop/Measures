//
//  InitialStartHeaderCell.swift
//  Shapely
//
//  Created by Andrew on 17.02.2023.
//

import UIKit
import SnapKit

final class MainHeaderCell: PreparableHeaderTableCell {

    private let titleLabel = with(UILabel()) {
        $0.apply(.screenTitle)
    }

    var props: MainHeaderCell.Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        prepareView()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func prepare(withViewModel viewModel: PreparableViewModel?) {
        guard let model = viewModel as? MainHeaderCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        contentView.apply(.backgroundColor)
        contentView.addSubview(titleLabel)
        makeConstraints()
    }

    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.title != newProps.title {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.03
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

extension MainHeaderCell {
    struct Props: Mutable {
        var title: String

        static let `default` = Props(title: "")
    }
}
