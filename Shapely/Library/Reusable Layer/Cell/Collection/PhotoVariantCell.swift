//
//  PhotoVariantCell.swift
//  Shapely
//
//  Created by Andrew on 25.03.2023.
//

import UIKit
import SnapKit

final class PhotoVariantCell: PreparableCollectionCell {

    private let imageView = with(UIImageView()) {
        $0.apply(.contentModeScaleAspectFit)
        ($0 as UIView).apply(.cornerRadius(Grid.xs.offset))
    }

    private let backView = with(UIView()) {
        $0.apply([.surfaceColor, .cornerRadius(Grid.xs.offset)])
    }

    var props: PhotoVariantCell.Props = .default {
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
        guard let model = viewModel as? PhotoVariantCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        contentView.apply(.backgroundColor)

        backView.addSubview(imageView)
        contentView.addSubview(backView)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        contentView.addGestureRecognizer(recognizer)

        makeConstraints()
    }

    private func makeConstraints() {
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.image != newProps.image {
            imageView.image = newProps.image?.scalePreservingAspectRatio(targetSize: CGSize(width: 70.0, height: 210.0))
        }
    }

    @objc private func onTap() {
        props.onTap.execute()
    }
}

extension PhotoVariantCell {
    struct Props: Mutable {
        var id: UUID?
        var image: UIImage?
        var onTap: Command

        static let `default` = Props(id: nil, image: nil, onTap: .empty)
    }
}
