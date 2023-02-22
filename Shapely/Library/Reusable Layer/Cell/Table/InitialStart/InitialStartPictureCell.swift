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

    private let gradientLayer = CAGradientLayer()

    private let gradientView = UIView()

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

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame.size = gradientView.frame.size
    }

    private func prepareView() {
        selectionStyle = .none
        contentView.apply(.backgroundColor)
        contentView.addSubview(pictureImageView)
        contentView.addSubview(gradientView)
        makeConstraints()
    }

    private func makeConstraints() {
        pictureImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Grid.sm.offset)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        gradientView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(Grid.ml.offset * 2)
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.picture != newProps.picture, let image = newProps.picture {
            pictureImageView.image = image

            gradientLayer.colors = [
              UIColor(red: 0.125, green: 0.122, blue: 0.118, alpha: 0).cgColor,
              UIColor(red: 0.125, green: 0.122, blue: 0.118, alpha: 1).cgColor
            ]
            gradientView.layer.addSublayer(gradientLayer)
            gradientView.layoutIfNeeded()
        }
    }
}

extension InitialStartPictureCell {
    struct Props: Mutable {
        var picture: UIImage?

        static let `default` = Props(picture: nil)
    }
}
