//
//  InitialStartTapeCell.swift
//  Shapely
//
//  Created by Andrew on 19.02.2023.
//

import UIKit
import SnapKit

final class InitialStartTapeCell: PreparableTableCell {

    private let valueLabel = with(UILabel()) {
        $0.apply(.measureValue)
    }

    private let measureLabel = with(UILabel()) {
        $0.apply(.measureType)
    }

//    private let markerIcon = with(UIImageView()) {
//        $0.apply(.defaultText)
//    }
//
//    private let stackView = with(UIStackView()) {
//        $0.apply(.defaultText)
//    }

//    private lazy var collectionView = with(UICollectionView()) {
//        $0.apply(.storesCategory)
//        $0.dataSource = self
//        $0.delegate = self
//        $0.register(StoresCell.self, forCellWithReuseIdentifier: StoresCell.className)
//    }

    var props: InitialStartTapeCell.Props = .default {
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
        guard let model = viewModel as? InitialStartTapeCellViewModel else {
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

extension InitialStartTapeCell {
    struct Props: Mutable {
//        var <#name#> = <#value#>

        static let `default` = Props()
    }
}
