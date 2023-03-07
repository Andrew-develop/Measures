//
//  PhotoProgressCell.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import UIKit
import SnapKit

final class PhotoProgressCell: PreparableTableCell {

    var props: PhotoProgressCell.Props = .default {
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
        guard let model = viewModel as? PhotoProgressCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        selectionStyle = .none

        makeConstraints()
    }

    private func makeConstraints() {}

    private func render(oldProps: Props, newProps: Props) {}
}

extension PhotoProgressCell {
    struct Props: Mutable {
//        var <#name#> = <#value#>

        static let `default` = Props()
    }
}
