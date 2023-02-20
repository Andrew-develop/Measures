//
//  InitialStartTapeCell.swift
//  Shapely
//
//  Created by Andrew on 19.02.2023.
//

import UIKit
import SnapKit

final class InitialStartTapeCell: PreparableTableCell {

    private let valueLabel = UILabel()

    private let markerImageView = with(UIImageView()) {
        $0.apply(.contentModeScaleToFill)
        $0.image = R.image.marker()
    }

    private let collectionLayout = with(UICollectionViewFlowLayout()) {
        $0.apply(.measures)
    }

    private lazy var collectionView = with(UICollectionView(frame: .zero,
                                                                    collectionViewLayout: collectionLayout)) {
        $0.apply(.measures)
        $0.dataSource = self
        $0.delegate = self
        $0.register(InitialStartTapeUnitCell.self, forCellWithReuseIdentifier: InitialStartTapeUnitCell.className)
    }

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
        contentView.apply(.backgroundColor)

        contentView.addSubviews(valueLabel, markerImageView, collectionView)
        makeConstraints()
    }

    private func makeConstraints() {
        collectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(90.0)
        }

        valueLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Grid.xs.offset)
            $0.center.equalToSuperview()
            $0.bottom.equalTo(collectionView.snp.top).offset(-Grid.ml.offset / 2)
        }

        markerImageView.snp.makeConstraints {
            $0.top.equalTo(valueLabel.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: Grid.s.offset, height: Grid.s.offset))
        }
    }

    private func render(oldProps: Props, newProps: Props) {
        if oldProps.items != newProps.items {
            collectionView.reloadData()
        }

        if oldProps.startValue != newProps.startValue, let measure = newProps.measureType {
            let valueText = NSMutableAttributedString(
                string: String(newProps.startValue),
                attributes: [
                    NSAttributedString.Key.font: DefaultTypography.header1,
                    NSAttributedString.Key.foregroundColor: DefaultColorPalette.button
                ])
            let space = NSAttributedString(string: " ")
            let measureText = NSAttributedString(
                string: measure.rawValue,
                attributes: [
                    NSAttributedString.Key.font: DefaultTypography.title4,
                    NSAttributedString.Key.foregroundColor: DefaultColorPalette.textSecondary
                ])
            valueText.append(space)
            valueText.append(measureText)
            valueLabel.attributedText = valueText
        }
    }
}

private extension InitialStartTapeCell {
//    func aaa() {
//        let cellWidth = 82
//        let collectionWidth = collectionView.frame.width
//        let contentWidth = collectionView.contentSize.width
//
//        let visibleCells = collectionView.visibleCells
//    }

//    func scrollToCell() {
//        var indexPath = IndexPath()
//        var visibleCells = collectionView.visibleCells
//
//        /// Gets visible cells
//        visibleCells = visibleCells.filter({ cell -> Bool in
//            let cellRect = collectionView.convert(
//                cell.frame,
//                to: collectionView.superview
//            )
//            /// Calculate if at least 50% of the cell is in the boundaries we created
//            let viewMidX = contentView.frame.midX
//            let cellMidX = cellRect.midX
//            let topBoundary = viewMidX + cellRect.width / 2
//            let bottomBoundary = viewMidX - cellRect.width / 2
//
//            /// A print state representating what the return is calculating
//            print("topboundary: \(topBoundary) > cellMidX: \(cellMidX) > Bottom Boundary: \(bottomBoundary)")
//            return topBoundary > cellMidX && cellMidX > bottomBoundary
//        })
//
//        /// Appends visible cell index to `cellIndexPath`
//        visibleCells.forEach({
//            if let selectedIndexPath = collectionView.indexPath(for: $0) {
//                indexPath = selectedIndexPath
//            }
//        })
//
//        let row = indexPath.row
//        // Disables animation on the first and last cell
//        if row == 0 || row == props.items.count - 1 {
//            self.select(row: row)
//            return
//        }
//        self.select(row: row)
//    }
}

extension InitialStartTapeCell: UICollectionViewDataSource {
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

extension InitialStartTapeCell: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            print(#function, collectionView.visibleCells.count)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(#function, collectionView.visibleCells.count)
    }
}

extension InitialStartTapeCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: InitialStartTapeCell.cellWidth, height: InitialStartTapeCell.cellHeight)
    }
}

private extension InitialStartTapeCell {
    static let cellWidth = 82.0
    static let cellHeight = 90.0
}

extension InitialStartTapeCell {
    struct Props: Mutable {
        var startValue: Double
        var measureType: Measure?
        var items: [InitialStartTapeUnitCellViewModel]
        var onChanged: CommandWith<Double>

        static let `default` = Props(startValue: 0, measureType: nil, items: [], onChanged: .empty)
    }
}
