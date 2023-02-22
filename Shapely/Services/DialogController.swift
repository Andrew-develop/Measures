//
//  DialogController.swift
//  Vladlink
//
//  Created by Pavel Zorin on 12.03.2021.
//

import SnapKit
import UIKit

class DialogController: UIViewController {
    // MARK: - Properties

    private let dialogView = with(UIView()) {
        $0.apply([.backgroundColor, .cornerRadius(Grid.s.offset)])
    }

    private let titleDialog = with(UILabel()) {
        $0.apply(.cellTitle)
    }

    private let textField = with(UITextField()) {
        $0.apply(.numeric)
    }

    private let backView = with(UIView()) {
        $0.apply([.surfaceColor, .cornerRadius(Grid.xs.offset)])
    }

    private let saveButton = with(UIButton()) {
        $0.apply(.alertContinueButton)
        $0.setTitle(R.string.localizable.buttonSave(), for: .normal)
    }

    var props: Props = .default {
        didSet { render(oldProps: oldValue, newProps: props) }
    }

    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
        prepareView()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Prepare View

    private func prepareView() {
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)

        backView.addSubview(textField)
        dialogView.addSubviews(titleDialog, backView, saveButton)
        view.addSubview(dialogView)

        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)

        makeConstraint()
    }

    // MARK: - Private Methods

    private func makeConstraint() {
        dialogView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width - Grid.m.offset)
        }

        titleDialog.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(Grid.s.offset)
        }

        backView.snp.makeConstraints {
            $0.top.equalTo(titleDialog.snp.bottom).offset(Grid.s.offset)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
        }

        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Grid.s.offset / 2)
            $0.leading.trailing.equalToSuperview().inset(Grid.s.offset)
        }

        saveButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(Grid.s.offset)
            $0.top.equalTo(backView.snp.bottom).offset(Grid.s.offset)
            $0.height.equalTo(Grid.ml.offset)
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.title != newProps.title, let title = newProps.title {
            titleDialog.text = title
        }

        if oldProps.value != newProps.value {
            showCurrentValue(newProps.value, measure: newProps.measure)
        }
    }

    // MARK: - Actions

    @objc private func saveAction() {
        dismiss(animated: true) { [weak self] in
            self?.props.onSave.execute(with: Int(self?.textField.text ?? ""))
        }
    }

    private func showCurrentValue(_ value: Int, measure: Measure) {
        let valueText = NSMutableAttributedString(
            string: String(value),
            attributes: [
                NSAttributedString.Key.font: DefaultTypography.body2,
                NSAttributedString.Key.foregroundColor: DefaultColorPalette.text
            ])
        let space = NSAttributedString(string: " ")
        let measureText = NSAttributedString(
            string: measure.rawValue,
            attributes: [
                NSAttributedString.Key.font: DefaultTypography.body2,
                NSAttributedString.Key.foregroundColor: DefaultColorPalette.textSecondary
            ])
        valueText.append(space)
        valueText.append(measureText)
        textField.attributedPlaceholder = valueText
    }
}

// MARK: - Props

extension DialogController {
    public struct Props: Mutable {
        var title: String?
        var value: Int
        var measure: Measure
        var onSave: CommandWith<Int?>

        public static let `default` = Props(title: nil, value: 0, measure: .sm, onSave: .empty)
    }
}
