//
//  EditableCell.swift
//  Shapely
//
//  Created by Andrew on 12.05.2023.
//

import UIKit
import SnapKit

class EditableCell: PreparableTableCell {

    private let editingStackView = with(EditingCellStack()) {
        ($0 as UIView).apply(.cornerRadius(Grid.xs.offset))
    }

    let backView = with(UIView()) {
        $0.apply([.surfaceColor, .cornerRadius(Grid.xs.offset)])
    }

    var editProps: EditableCell.Props = .default {
        didSet { render(oldProps: oldValue, newProps: editProps) }
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
        guard let model = viewModel as? EditableCellViewModel else {
            return
        }
        self.editProps = model.editProps
    }

    private func prepareView() {
        selectionStyle = .none
        contentView.apply(.backgroundColor)
        contentView.addSubviews(backView, editingStackView)

        makeConstraints()
        setBasePosition()
    }

    private func makeConstraints() {
        editingStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(Grid.m.offset)
            $0.trailing.equalToSuperview().offset(-Grid.xs.offset)
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.isEditable != newProps.isEditable {
            if newProps.isEditable {
                setControlPosition()
            } else {
                setBasePosition()
            }
            setupSubviews()
        }
    }

    private func setBasePosition() {
        backView.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(Grid.s.offset)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        editingStackView.isHidden = true
    }

    private func setControlPosition() {
        backView.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(Grid.s.offset)
            $0.leading.bottom.equalToSuperview()
            $0.trailing.equalTo(editingStackView.snp.leading).offset(-Grid.xs.offset)
        }

        editingStackView.isHidden = false
    }

    func setupSubviews() {}
}

extension EditableCell {
    struct Props: Mutable, Equatable {
        var isEditable: Bool
        var onDelete: Command

        static let `default` = Props(isEditable: false, onDelete: .empty)

        static func == (lhs: EditableCell.Props, rhs: EditableCell.Props) -> Bool {
            lhs.isEditable == rhs.isEditable
        }
    }
}
