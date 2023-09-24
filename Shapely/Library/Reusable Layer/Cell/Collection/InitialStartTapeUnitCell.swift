//
//  InitialStartTapeUnitCell.swift
//  Shapely
//
//  Created by Andrew on 20.02.2023.
//

import UIKit
import SnapKit

final class InitialStartTapeUnitCell: PreparableCollectionCell {

    private let valueLabel = with(UILabel()) {
        $0.apply(.unitValue)
    }

    private let markerImageView = with(UIImageView()) {
        $0.apply(.contentModeScaleToFill)
        $0.image = R.image.unit()
    }

    var props: InitialStartTapeUnitCell.Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func prepare(withViewModel viewModel: PreparableViewModel?) {
        guard let model = viewModel as? InitialStartTapeUnitCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        contentView.clipsToBounds = false
        contentView.apply(.backgroundColor)

        contentView.addSubviews(markerImageView, valueLabel)
        makeConstraints()
    }

    private func makeConstraints() {
        markerImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Grid.s.offset)
        }

        valueLabel.snp.makeConstraints {
            $0.top.equalTo(markerImageView.snp.bottom)
            $0.centerX.equalTo(markerImageView.snp.trailing).offset(-Grid.xs.offset / 2)
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.currentValue != newProps.currentValue {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.24
            valueLabel.attributedText = NSMutableAttributedString(
                string: newProps.currentValue,
                attributes: [
                    NSAttributedString.Key.kern: -0.41,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]
            )
        }
    }
}

extension InitialStartTapeUnitCell {
    struct Props: Mutable {
        var currentValue: String

        static let `default` = Props(currentValue: "")
    }
}
