//
//  MainControlHeaderCell.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import UIKit
import SnapKit

final class MainControlHeaderCell: PreparableHeaderTableCell {

    private let titleLabel = with(UILabel()) {
        $0.apply(.screenTitle)
    }

    private let controlButton = with(UIButton()) {
        $0.apply(.controlButton)
    }

    var props: MainControlHeaderCell.Props = .default {
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
        guard let model = viewModel as? MainControlHeaderCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        contentView.apply(.backgroundColor)
        contentView.addSubviews(titleLabel, controlButton)

        controlButton.addTarget(self, action: #selector(onTap), for: .touchUpInside)

        makeConstraints()
    }

    private func makeConstraints() {
        controlButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: Grid.sm.offset, height: Grid.sm.offset))
        }

        titleLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalTo(controlButton.snp.leading).offset(-Grid.xs.offset)
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

    @objc private func onTap() {
        props.onTap.execute()
    }
}

extension MainControlHeaderCell {
    struct Props: Mutable {
        var title: String
        var onTap: Command

        static let `default` = Props(title: "", onTap: .empty)
    }
}
