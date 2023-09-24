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
            $0.height.equalTo(InitialStartTapeCell.cellHeight)
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

        if oldProps.startValue != newProps.startValue {
            calculateStartPosition()
            showCurrentValue(newProps.startValue, measure: newProps.measureType)
        }
    }
}

private extension InitialStartTapeCell {
    func calculatePosition() {
        let markerPosition = collectionView.contentOffset.x + collectionView.frame.width / 2.0
        let numberOfCell = Double(markerPosition / InitialStartTapeCell.unitWidth)
        let correctInterval = Double(props.range.first ?? 0) - 0.9
        let currentValue = numberOfCell + correctInterval
        let valueToShow = round(Double(currentValue) * 10) / 10

        props.onChanged.execute(with: valueToShow)
    }

    func calculateStartPosition() {
        let correctInterval = props.startValue - Double(props.range.first ?? 0) - 1.0
        let offset = correctInterval * InitialStartTapeCell.unitWidth - Grid.xs.offset
        collectionView.layoutIfNeeded()
        collectionView.setContentOffset(CGPoint(x: offset, y: 0.0), animated: false)
    }

    func showCurrentValue(_ value: Double, measure: Measure) {
        let valueText = NSMutableAttributedString(
            string: String(value),
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
            calculatePosition()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        calculatePosition()
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
    static let unitWidth = cellWidth + Grid.xs.offset
}

extension InitialStartTapeCell {
    struct Props: Mutable {
        var startValue: Double
        var measureType: Measure
        var range: Range<Int>
        var items: [InitialStartTapeUnitCellViewModel]
        var onChanged: CommandWith<Double>

        static let `default` = Props(startValue: 0, measureType: .sm, range: Range(0...0), items: [], onChanged: .empty)
    }
}
