//
//  StatisticsCell.swift
//  Shapely
//
//  Created by Andrew on 27.03.2023.
//

import UIKit
import SnapKit

final class StatisticsCell: EditableCell {

    private let collectionLayout = with(UICollectionViewFlowLayout()) {
        $0.apply(.statistics)
    }

    private lazy var collectionView = with(UICollectionView(frame: .zero,
                                                                    collectionViewLayout: collectionLayout)) {
        $0.apply(.statistics)
        $0.dataSource = self
        $0.delegate = self
        $0.register(StatisticsPointCell.self, forCellWithReuseIdentifier: StatisticsPointCell.className)
    }

    var props: StatisticsCell.Props = .default {
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
        guard let model = viewModel as? StatisticsCellViewModel else {
            return
        }
        self.props = model.props
        self.editProps = model.editProps
    }

    private func prepareView() {
        backView.addSubview(collectionView)

        makeConstraints()
    }

    private func makeConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Grid.s.offset)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(contentView.frame.width / 1.5)
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.items != newProps.items {
            collectionView.reloadData()
        }
    }
}

extension StatisticsCell: UICollectionViewDataSource {
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

extension StatisticsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = StatisticsCell.sectionInsets.left * (StatisticsCell.itemsPerRow + 1)
        let additionalOffset = !editProps.isEditable ? 0 : Grid.ml.offset
        let availableWidth = contentView.frame.width - paddingSpace - additionalOffset
        let widthPerItem = availableWidth / StatisticsCell.itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem / 1.20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        StatisticsCell.sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        StatisticsCell.sectionInsets.left
    }
}

private extension StatisticsCell {
    static let itemsPerRow: CGFloat = 3
    static let sectionInsets = UIEdgeInsets(top: Grid.s.offset, left: Grid.s.offset,
                                            bottom: Grid.s.offset, right: Grid.s.offset)
}

extension StatisticsCell {
    struct Props: Mutable {
        var id: UUID?
        var items: [StatisticsPointCellViewModel]

        static let `default` = Props(id: nil, items: [])
    }
}
