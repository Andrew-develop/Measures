//
//  InitialStartPictureCell.swift
//  Shapely
//
//  Created by Andrew on 17.02.2023.
//

import UIKit
import SnapKit

final class InitialStartPictureCell: PreparableTableCell {

    private let pictureImageView = with(UIImageView()) {
        $0.apply(.contentModeScaleToFill)
    }

    var props: InitialStartPictureCell.Props = .default {
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
        guard let model = viewModel as? InitialStartPictureCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        selectionStyle = .none
        contentView.apply(.backgroundColor)
        contentView.addSubview(pictureImageView)
        makeConstraints()
    }

    private func makeConstraints() {
        pictureImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Grid.sm.offset)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.picture != newProps.picture, let image = newProps.picture {
            pictureImageView.image = image
        }
    }
}

extension InitialStartPictureCell {
    struct Props: Mutable {
        var picture: UIImage?

        static let `default` = Props(picture: nil)
    }
}
