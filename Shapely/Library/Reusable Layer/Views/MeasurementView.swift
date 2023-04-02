//
//  MeasurementView.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import UIKit

final class MeasurementView: UIView {
    private let titleLabel = with(UILabel()) {
        $0.apply(.defaultText)
    }

    private let subtitleLabel = with(UILabel()) {
        $0.apply(.footnoteText)
    }

    private let iconImageView = with(UIImageView()) {
        $0.apply(.contentModeScaleToFill)
    }

    private let imageBackView = with(UIView()) {
        $0.apply([.buttonColor, .cornerRadius(Grid.xs.offset)])
    }

    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)
        prepareView()
    }

    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MeasurementView {
    func prepareView() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(recognizer)

        imageBackView.addSubview(iconImageView)
        addSubviews(titleLabel, subtitleLabel, imageBackView)
        makeConstraints()
    }

    func makeConstraints() {
        iconImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Grid.xs.offset / 2)
            $0.size.equalTo(CGSize(width: Grid.sm.offset, height: Grid.sm.offset))
        }

        imageBackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Grid.xs.offset / 2)
            $0.leading.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(imageBackView.snp.trailing).offset(Grid.xs.offset)
            $0.trailing.equalToSuperview().offset(-Grid.xs.offset)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
        }
    }

    func render(oldProps: Props, newProps: Props) {
        if oldProps.title != newProps.title {
            titleLabel.text = newProps.title
        }

        if oldProps.subTitle != newProps.subTitle {
            subtitleLabel.text = newProps.subTitle
            iconImageView.image = newProps.subTitle == R.string.localizable.measurementEmpty() ?
            R.image.plus() : R.image.edit()
        }

        if oldProps.isHidden != newProps.isHidden {
            isHidden = newProps.isHidden
        }
    }

    @objc func onTap() {
        props.onTap.execute()
    }
}

extension MeasurementView {
    struct Props: Mutable, Equatable {
        var isHidden: Bool
        var title: String
        var subTitle: String
        var onTap: Command

        static var `default` = Props(isHidden: false, title: "", subTitle: "", onTap: .empty)

        static func == (lhs: MeasurementView.Props, rhs: MeasurementView.Props) -> Bool {
            lhs.title == rhs.title &&
            lhs.subTitle == rhs.subTitle &&
            lhs.isHidden == rhs.isHidden
        }
    }
}
