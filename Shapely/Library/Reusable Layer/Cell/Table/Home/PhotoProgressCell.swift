//
//  PhotoProgressCell.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import UIKit
import SnapKit

final class PhotoProgressCell: PreparableTableCell {

    private let firstImageView = with(UIImageView()) {
        $0.apply(.contentModeScaleAspectFit)
        ($0 as UIView).apply([.backgroundColor, .cornerRadius(Grid.xs.offset)])
    }

    private let lastImageView = with(UIImageView()) {
        $0.apply(.contentModeScaleAspectFit)
        ($0 as UIView).apply([.backgroundColor, .cornerRadius(Grid.xs.offset)])
    }

    private let iconImageView = with(UIImageView()) {
        $0.apply(.contentModeScaleToFill)
        $0.image = R.image.progressArrow()
    }

    private let stackView = with(UIStackView()) {
        $0.apply(.photoProgress)
    }

    private let backView = with(UIView()) {
        $0.apply([.surfaceColor, .cornerRadius(Grid.s.offset)])
    }

    var props: PhotoProgressCell.Props = .default {
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
        guard let model = viewModel as? PhotoProgressCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        selectionStyle = .none
        contentView.apply(.backgroundColor)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        contentView.addGestureRecognizer(recognizer)

        stackView.addArrangedSubview(firstImageView)
        stackView.addArrangedSubview(lastImageView)
        backView.addSubviews(stackView, iconImageView)
        contentView.addSubviews(backView)

        makeConstraints()
    }

    private func makeConstraints() {
        backView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Grid.sm.offset)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        let width = contentView.frame.width / 2 - Grid.sm.offset

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Grid.xs.offset)
            $0.height.equalTo(width * 1.5)
        }

        iconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.firstImage != newProps.firstImage, let image = newProps.firstImage {
            firstImageView.image = image
        }

        if oldProps.lastImage != newProps.lastImage, let image = newProps.lastImage {
            lastImageView.image = image
        }
    }

    @objc private func onTap() {
        props.onTap.execute()
    }
}

extension PhotoProgressCell {
    struct Props: Mutable {
        var firstImage: UIImage?
        var lastImage: UIImage?
        var onTap: Command

        static let `default` = Props(firstImage: nil, lastImage: nil, onTap: .empty)
    }
}
