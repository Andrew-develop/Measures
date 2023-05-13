//
//  DayPhotosCell.swift
//  Shapely
//
//  Created by Andrew on 12.05.2023.
//

import UIKit
import SnapKit

final class DayPhotosCell: PreparableTableCell {

    private let firstImageView = with(UIImageView()) {
        $0.apply(.contentModeScaleAspectFit)
        ($0 as UIView).apply([.backgroundColor, .cornerRadius(Grid.xs.offset)])
    }

    private let secondImageView = with(UIImageView()) {
        $0.apply(.contentModeScaleAspectFit)
        ($0 as UIView).apply([.backgroundColor, .cornerRadius(Grid.xs.offset)])
    }

    private let thirdImageView = with(UIImageView()) {
        $0.apply(.contentModeScaleAspectFit)
        ($0 as UIView).apply([.backgroundColor, .cornerRadius(Grid.xs.offset)])
    }

    private let stackView = with(UIStackView()) {
        $0.apply(.photoProgress)
    }

    private let backView = with(UIView()) {
        $0.apply([.surfaceColor, .cornerRadius(Grid.xs.offset)])
    }

    var props: DayPhotosCell.Props = .default {
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
        guard let model = viewModel as? DayPhotosCellViewModel else {
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
        stackView.addArrangedSubview(secondImageView)
        stackView.addArrangedSubview(thirdImageView)

        backView.addSubview(stackView)
        contentView.addSubviews(backView)

        makeConstraints()
    }

    private func makeConstraints() {
        let width = contentView.frame.width / 2 - Grid.sm.offset

        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Grid.xs.offset)
            $0.height.equalTo(width * 1.5)
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.firstImage != newProps.firstImage, let image = newProps.firstImage {
            firstImageView.image = image
        }

        if oldProps.secondImage != newProps.secondImage, let image = newProps.secondImage {
            secondImageView.image = image
        }

        if oldProps.thirdImage != newProps.thirdImage, let image = newProps.thirdImage {
            thirdImageView.image = image
        }
    }

    @objc private func onTap() {
        props.onTap.execute()
    }
}

extension DayPhotosCell {
    struct Props: Mutable {
        var firstImage: UIImage?
        var secondImage: UIImage?
        var thirdImage: UIImage?
        var onTap: Command

        static let `default` = Props(firstImage: nil, secondImage: nil, thirdImage: nil, onTap: .empty)
    }
}
