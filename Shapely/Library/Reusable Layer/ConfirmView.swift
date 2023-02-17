//
//  ConfirmView.swift
//  Shapely
//
//  Created by Andrew on 17.02.2023.
//

import UIKit

final class ConfirmView: UIView {
    private let continueButton = with(UIButton()) {
        ($0 as UIView).apply([.buttonColor, .cornerRadius(Grid.s.offset)])
    }

    private let backButton = with(UIButton()) {
        ($0 as UIView).apply([.surfaceColor, .cornerRadius(Grid.s.offset)])
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

private extension ConfirmView {
    func prepareView() {
        (self as UIView).apply(.backgroundColor)
        continueButton.titleLabel?.apply(.body1)

        continueButton.addTarget(self, action: #selector(onContinue), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(onBack), for: .touchUpInside)

        addSubviews(continueButton, backButton)
        makeConstraints()
    }

    func makeConstraints() {
        setRegularPosition()
        backButton.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalTo(self.snp.height)
        }
    }

    func render(oldProps: Props, newProps: Props) {
        if oldProps.title != newProps.title {
            continueButton.setTitle(newProps.title, for: .normal)
        }
        if oldProps.state != newProps.state {
            switch newProps.state {
            case .regular:
                setRegularPosition()
            case .full:
                setFullPosition()
            }
        }
    }

    func setRegularPosition() {
        continueButton.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        backButton.isHidden = true
    }

    func setFullPosition() {
        continueButton.snp.remakeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(backButton.snp.trailing).offset(Grid.xs.offset)
        }
        backButton.isHidden = false
    }

    @objc func onContinue() {
        props.onContinue.execute()
    }

    @objc func onBack() {
        props.onBack.execute()
    }
}

extension ConfirmView {
    struct Props: Mutable, Equatable {
        var state: State
        var title: String
        var onContinue: Command
        var onBack: Command

        static var `default` = Props(state: .regular, title: "", onContinue: .empty, onBack: .empty)

        static func == (lhs: ConfirmView.Props, rhs: ConfirmView.Props) -> Bool {
            lhs.state == rhs.state && lhs.title == rhs.title
        }
    }

    enum State {
        case regular
        case full
    }
}
