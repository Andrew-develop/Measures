//
//  InitialStartSegmentCell.swift
//  Shapely
//
//  Created by Andrew on 18.02.2023.
//

import UIKit
import SnapKit

final class InitialStartSegmentCell: PreparableTableCell {

    private let genderSegment = with(UISegmentedControl()) {
        $0.apply(.gender)
    }

    var props: InitialStartSegmentCell.Props = .default {
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
        guard let model = viewModel as? InitialStartSegmentCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        selectionStyle = .none
        contentView.apply(.backgroundColor)
        contentView.addSubview(genderSegment)

        genderSegment.addTarget(self, action: #selector(segmentControlAction), for: .valueChanged)
        makeConstraints()
    }

    private func makeConstraints() {
        genderSegment.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Grid.sm.offset)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(Grid.l.offset)
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.selectedSegmentIndex != newProps.selectedSegmentIndex,
           let index = newProps.selectedSegmentIndex {
            genderSegment.selectedSegmentIndex = index
        }
    }

    @objc private func segmentControlAction() {
        props.onSegmentChanged.execute(with: genderSegment.selectedSegmentIndex)
    }
}

extension InitialStartSegmentCell {
    struct Props: Mutable {
        var selectedSegmentIndex: Int?
        var onSegmentChanged: CommandWith<Int>

        static let `default` = Props(selectedSegmentIndex: nil, onSegmentChanged: .empty)
    }
}
