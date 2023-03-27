//
//  PhotoTypesCell.swift
//  Shapely
//
//  Created by Andrew on 25.03.2023.
//

import UIKit
import SnapKit

final class PhotoTypesCell: PreparableTableCell {

    private let collectionLayout = with(UICollectionViewFlowLayout()) {
        $0.apply(.photoCollage)
    }

    private lazy var collectionView = with(UICollectionView(frame: .zero,
                                                                    collectionViewLayout: collectionLayout)) {
        $0.apply(.measures)
        $0.dataSource = self
        $0.register(PhotoVariantCell.self, forCellWithReuseIdentifier: PhotoVariantCell.className)
    }

    var props: PhotoTypesCell.Props = .default {
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
        guard let model = viewModel as? PhotoTypesCellViewModel else {
            return
        }
        self.props = model.props
    }

    private func prepareView() {
        selectionStyle = .none
        contentView.apply(.backgroundColor)
        contentView.addSubview(collectionView)

        makeConstraints()
    }

    private func makeConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Grid.s.offset)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(PhotoTypesCell.cellHeight)
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.items != newProps.items {
            collectionView.reloadData()
        }
    }
}

extension PhotoTypesCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        props.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: props.items[indexPath.row].cellId, for: indexPath)
        if let reusableCell = cell as? PreparableCollectionCell {
            reusableCell.prepare(withViewModel: props.items[indexPath.row])
        }
        return cell
    }
}

private extension PhotoTypesCell {
    static let cellWidth = 70.0
    static let cellHeight = 210.0
}

extension PhotoTypesCell {
    struct Props: Mutable {
        var id: UUID?
        var items: [PhotoVariantCellViewModel]

        static let `default` = Props(id: nil, items: [])
    }
}
