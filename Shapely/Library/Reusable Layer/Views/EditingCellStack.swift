//
//  EditingCellStack.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import UIKit

final class EditingCellStack: UIView {
    private let moveButton = with(UIButton()) {
        $0.apply(.moveButton)
    }

    private let deleteButton = with(UIButton()) {
        $0.apply(.deleteButton)
    }

    private let stackView = with(UIStackView()) {
        $0.apply(.editingCell)
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

private extension EditingCellStack {
    func prepareView() {
        (self as UIView).apply(.surfaceColor)

        deleteButton.addTarget(self, action: #selector(onDelete), for: .touchUpInside)

        stackView.addArrangedSubview(moveButton)
        stackView.addArrangedSubview(deleteButton)
        addSubview(stackView)

        makeConstraints()
    }

    func makeConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        [moveButton, deleteButton].forEach { button in
            button.snp.makeConstraints {
                $0.size.equalTo(CGSize(width: Grid.m.offset, height: Grid.m.offset))
            }
        }
    }

    func render(oldProps: Props, newProps: Props) {}

    @objc func onDelete() {
        props.onDelete.execute()
    }
}

extension EditingCellStack {
    struct Props: Mutable {
        var onDelete: Command

        static var `default` = Props(onDelete: .empty)
    }
}
